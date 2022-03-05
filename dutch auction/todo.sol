// SPDX-License-Identifier: MIT
pragma solidity ^0.8.3;

contract Todo{
    event Create(uint index, address creater, string description);
    event Update(uint index, address creater, string description);
    event complete(uint index, address creater);
    
    struct todoItem{
       string description;
       bool isCompleted;
    }

    todoItem[] public todoList;

    function create(string calldata _description) external{
        // todoItem item;
        // item = todoItem(_description, false);
        // todoList[todoList.length] = item;
        //or
        todoList.push(todoItem({
            description:_description,
            isCompleted:false
        }));

        emit Create(todoList.length,msg.sender, _description);
    }

    function updateTodoDescription(uint _index,string calldata _description) external{
        require(_index<todoList.length,"can not update");
        // todoItem item;
        // item = todoItem(_description,false);
        // todoList[_index] = item;

        //or
        todoList[_index].description = _description; //less gas if only some fields need to be updated
        //or    
        //todoItme item =todoList[_index] //less gas if many things to be updated
        //item.description = _description

        emit Update(_index,msg.sender, _description);
    }

    function toggleCompleted(uint _index) external{
        require(_index<todoList.length,"can not update");
        todoList[_index].isCompleted = true;

        emit complete(_index,msg.sender);
    }



}