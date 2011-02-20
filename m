From: Mark Lord <kernel@teksavvy.com>
Subject: Re: ext4 crash on 2.6.37: NULL ptr in ext4_discard_preallocations
Date: Sun, 20 Feb 2011 00:05:27 -0500
Message-ID: <4D60A117.8090604@teksavvy.com>
References: <4D604620.9060204@teksavvy.com> <20110220000550.GA8765@thunk.org> <4D609E87.5000903@teksavvy.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
To: Ted Ts'o <tytso@mit.edu>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	linux-ext4@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4D609E87.5000903@teksavvy.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 11-02-19 11:54 PM, Mark Lord wrote:
> On 11-02-19 07:05 PM, Ted Ts'o wrote:
>> On Sat, Feb 19, 2011 at 05:37:20PM -0500, Mark Lord wrote:
>>> 32-bit x86 system, 2.6.37 SMP kernel, Core2duo, 3.3GB RAM, no swap.
>>>
>>> The system just suddenly switched to fbconsole and dumped a traceback.
>>> Here's the screen-shot photo:  http://rtr.ca/ext4_crash.jpg
>>>
>>> Is this a known bug that got fixed in 2.6.37.1 ?
>>
>> No, this looks like a new one.
>>
>> And I can't make the Code: line make sense.  Can you send me the
>> fs/ext4/mballoc.s file after running the command "make
>> fs/ext4/mballoc.s" in your build tree where you built this kernel?
> 
> Sent.  And here's an extract:
> 
> .globl ext4_discard_preallocations
>         .type   ext4_discard_preallocations, @function
> ext4_discard_preallocations:
>         pushl   %ebp    #
>         pushl   %edi    #
>         leal    -136(%eax), %edi        #, ei
>         pushl   %esi    #
>         pushl   %ebx    #
>         subl    $80, %esp       #,
>         movl    172(%eax), %esi # <variable>.i_sb, sb
>         movl    $0, 76(%esp)    #, group
>         movzwl  122(%eax), %edx # <variable>.i_mode, tmp85
>         andl    $61440, %edx    #, tmp85
>         cmpl    $32768, %edx    #, tmp85
>         jne     .L875   #,
>         leal    68(%esp), %edx  #, tmp86
>         leal    380(%eax), %ebx #, D.45176
>         movl    %edx, 68(%esp)  # tmp86, list.next
>         addl    $372, %eax      #,
>         movl    %edx, 72(%esp)  # tmp86, list.prev
>         movl    %eax, 28(%esp)  #, %sfp
> .L876:
>         movl    %ebx, %eax      # D.45176,
>         call    _raw_spin_lock  #
>         jmp     .L861   #
> .L867:
>         cmpl    %ebx, 60(%ebp)  # D.45176, <variable>.pa_obj_lock
>         je      .L862   #,
> #APP
> # 3810 "fs/ext4/mballoc.c" 1
>         1:      ud2
> 
> I wonder if the 003c offset is that "cmpl %ebx, 60(%ebp)" line?

I suppose it must be, as there's no other 0x3c offset in that function.
Which means it's probably this line that's crashing:

             BUG_ON(pa->pa_obj_lock != &ei->i_prealloc_lock);

...which could only happen if "pa" was NULL there.
I wonder how that happened ?
