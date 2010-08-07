From: "Justin P. Mattock" <justinmattock@gmail.com>
Subject: Re: kernel BUG at fs/ext4/mballoc.c:2993!
Date: Sat, 07 Aug 2010 00:46:35 -0700
Message-ID: <4C5D0F5B.90103@gmail.com>
References: <AANLkTinPtkUsVz6GYBgYMfgGKTJ88cyRfvdLcjtE5m4x@mail.gmail.com> <20100807064513.GD28087@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: Ted Ts'o <tytso@mit.edu>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	gcc@gcc.gnu.org, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:57878 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752094Ab0HGHqW (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 7 Aug 2010 03:46:22 -0400
In-Reply-To: <20100807064513.GD28087@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 08/06/2010 11:45 PM, Ted Ts'o wrote:
> On Fri, Aug 06, 2010 at 10:48:40PM -0700, Justin Mattock wrote:
>> hello,
>> I just built a fresh clfs system using the tutorial.. right now Im
>> able to boot and am able to login, the system seems to be running as
>> it should except for when I try to install gmp and/or do a /sbin/lilo
>> I see a message appear on screen(below) then if I do any kind of
>> command(dmesg>  dmesg) I get a stuck screen. has there been anything
>> similar to the below message?
>>
>> keep in mind the kernel I'm using is 2.6.35-rc6 which on other
>> machines(same type of system) run just fine without such message.
>
> Um, is this a completely modified 2.6.35-rc6 kernel?  The reason why I
> ask is there is no BUG_ON at line fs/ext4/mballoc.c:2993 for that
> kernel version.

no not modified at all. current git commit: 2.6.35-rc6-00191-ga2dccdb
but says 2.6.35-rc6 because git is not installed yet on this system.
(I was able to use ohci1394_dma=early to capture this, no ssh yet)
>
> There are two BUG_ON statements nearby, but given the line number
> doesn't match up with either one, it's hard to say for sure which one
> triggered it.  What were the kernel messages right before the BUG_ON?
> was there a "start NNNNN size NNN, fe_logical NNNN" (where NNNN is
> some number) right before the "cut here" message?
>
> Have you tried forcing an fsck run on the file system to make sure
> it's not caused by a file-system corruption?
>

before the cut here message I have loads of avc denials from SELinux 
showing up in the log, after the avc's denials I see this:

EXT4-fs (sda3): re-mounted. Opts: errors=remount-ro,user_xattr
EXT4-fs (sda3): re-mounted. Opts: errors=remount-ro,user_xattr

as for fsck I did not do that, but just saw on a reboot that it had 
fired off with nothing stating corruption or anything.

> And have you tried using a standard released gcc so we can determine
> for sure whether this is a potential kernel bug, file system
> corruption issue, or gcc issue?
>
> 							- Ted
>

this is strange.. I ended up taking a kernel from another 
machine(literally the same kernel) loaded it up etc.. after booting up 
doing /sbin/lilo worked, installing gmp worked.. prior too make install 
with gmp would trigger this half way through the installation reliably 
as well as /sbin/lilo, and now nothing of the sort of what I posted.
After testing the other machines kernel I recompiled the kernel on the 
new system rebooted and did those steps to reproduce with nothing of the 
sort of what I had posted as well.

The only thing I can think of is during my building of the system, is 
maybe this was happening because I built the kernel as root i.e. I 
usually will chroot towards the end of building a system, build the 
kernel as root, check the symlinks, configurations, then tar ball the 
whole thing and transfer, then once booted into the new system, start 
building everything all over again.

as for the gcc version I'm using 4.6.0 20100731 as for this being the 
culprit.. not sure if building the kernel as root causes gcc to change 
things with this version of gcc or not..

Right now, as I write things look normal again, I've done /sbin/lilo 
numerous times with all a success, and built gmp mpfr just to make sure 
with all being a success.

Justin P. Mattock






