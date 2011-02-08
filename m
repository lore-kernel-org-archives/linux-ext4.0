From: Tao Ma <tm@tao.ma>
Subject: Re: [BUG] v2.6.38-rc3+ BUG when calling destroy_inodecache at module
 unload
Date: Tue, 08 Feb 2011 23:25:51 +0800
Message-ID: <4D51607F.9050103@tao.ma>
References: <4D4AF928.9030609@panasas.com> <4D4BBAAB.4070500@tao.ma> <1296846886-sup-1431@think> <4D515713.1070106@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Chris Mason <chris.mason@oracle.com>,
	Nick Piggin <npiggin@gmail.com>,
	Al Viro <viro@ZenIV.linux.org.uk>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	ext4 development <linux-ext4@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Rafael J. Wysocki" <rjw@sisk.pl>
To: Boaz Harrosh <bharrosh@panasas.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <4D515713.1070106@panasas.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi Boaz,
On 02/08/2011 10:45 PM, Boaz Harrosh wrote:
> On 02/04/2011 09:15 PM, Chris Mason wrote:
>    
>> Excerpts from Tao Ma's message of 2011-02-04 03:36:59 -0500:
>>      
>>> On 02/04/2011 02:51 AM, Boaz Harrosh wrote:
>>>        
>>>> Last good Kernel was 2.6.37
>>>> I'm doing a "mount" then "unmount". I think root is the only created inode.
>>>> rmmod is called immediately after "unmount" within a script
>>>>
>>>> if I only do unmount and manually call "modprobe --remove exofs" after a small while
>>>> all is fine.
>>>>
>>>> I get:
>>>> slab error in kmem_cache_destroy(): cache `exofs_inode_cache': Can't free all objects
>>>> Call Trace:
>>>> 77dfde08:  [<6007e9a6>] kmem_cache_destroy+0x82/0xca
>>>> 77dfde38:  [<7c1fa3da>] exit_exofs+0x1a/0x1c [exofs]
>>>> 77dfde48:  [<60054c10>] sys_delete_module+0x1b9/0x217
>>>> 77dfdee8:  [<60014d60>] handle_syscall+0x58/0x70
>>>> 77dfdf08:  [<60024163>] userspace+0x2dd/0x38a
>>>> 77dfdfc8:  [<600126af>] fork_handler+0x62/0x69
>>>>
>>>>          
>>> I also get a similar error when testing ext4 and a bug is opened there.
>>>
>>> https://bugzilla.kernel.org/show_bug.cgi?id=27652
>>>
>>> And I have done some simple investigation for ext4 and It looks as if now with the new *fs_i_callback doesn't free the inode to *fs_inode_cache immediately. So the old logic will destroy the inode cache before we free all the inode object.
>>>
>>> Since there are more than one fs affected by this, we may need to find a way in the VFS.
>>>        
>> Sounds like we just need a synchronize_rcu call before we delete the
>> cache?
>>
>> -chris
>>      
> Hi Al, Nick.
>
> Al please look into this issue. Absolutely all filesystems should be affected.
> Tao Ma has attempted the below fix, but it does not help. Exact same trace
> with his patch applied.
>    
I am in vacation so I could't reach my test box today. I have done some 
simple tracing yesterday, and it looked that although synchronize_rcu is 
called, I can still get ext4_i_callback after it.
So the reason may be:
1. synchronize_rcu doesn't work as we expected.
2. the inode free rcu doesn't work as Nick expected.

I will go to the office tomorrow and do more test and debug there. Hope 
to find something more.
> If you unmount and immediately rmmod the filesystem it will crash because of
> those RCU freed objects at umount, like the root inode. Nick is not responding,
> I'd try to fix it, but I don't know how.
>    
I raised the error to Nick on Jan. 19, about 3 weeks ago.
http://marc.info/?l=linux-ext4&m=129542001031750&w=2
But it seems that he is quite busy these days. It is still rc3 and we 
have a lot of time before the final release. So no panic here. ;)
Finally, I just tried to fix it recently. But it doesn't work. :( I will 
continue to work on it before Al or Nick respond with a perfect patch. :)

Regards,
Tao
