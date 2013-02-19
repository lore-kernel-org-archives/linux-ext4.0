From: Li Zefan <lizefan@huawei.com>
Subject: Re: [RFC][PATCH] vfs: always protect diretory file->fpos with inode
 mutex
Date: Tue, 19 Feb 2013 20:43:14 +0800
Message-ID: <51237362.201@huawei.com>
References: <5122D3E0.6070800@huawei.com> <20130219123344.GA18350@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Cc: <linux-fsdevel@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Jan Kara <jack@suse.cz>, "Theodore Ts'o" <tytso@mit.edu>,
	Andrew Morton <akpm@linux-foundation.org>,
	<andi@firstfloor.org>, Wuqixuan <wuqixuan@huawei.com>,
	Al Viro <viro@ZenIV.linux.org.uk>, <gregkh@linuxfoundation.org>
To: <gnehzuil.liu@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20130219123344.GA18350@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 2013/2/19 20:33, Zheng Liu wrote:
> On Tue, Feb 19, 2013 at 09:22:40AM +0800, Li Zefan wrote:
>> There's a long long-standing bug...As long as I don't know when it dates
>> from.
>>
>> I've written and attached a simple program to reproduce this bug, and it can
>> immediately trigger the bug in my box. It uses two threads, one keeps calling
>> read(), and the other calling readdir(), both on the same directory fd.
> 
> Hi Zefan,
> 
> Out of curiosity, why do you call read(2) on a directory fd?  I only
> open(2) a directory in order to execute a flush operation to make sure
> that a file is really created.
> 

Because something wrong happened in userspace programs.

After a thread closed a socket, another thread is still reading data from
this socket, but the socket fd has been re-used for opening directory for
readdir()!
