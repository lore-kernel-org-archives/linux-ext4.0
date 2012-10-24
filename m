From: Martin <marogge@onlinehome.de>
Subject: Re: Apparent serious progressive ext4 data corruption bug in 3.6.3
 (and other stable branches?)
Date: Wed, 24 Oct 2012 19:38:15 +0200
Message-ID: <50882787.3030504@onlinehome.de>
References: <jXsTo-5lW-13@gated-at.bofh.it> <jXBDk-7vn-13@gated-at.bofh.it> <jXNl8-5m5-13@gated-at.bofh.it> <jXNOa-5MR-23@gated-at.bofh.it> <jXPGh-87s-5@gated-at.bofh.it> <jXTJW-4CH-55@gated-at.bofh.it> <jXUZj-6mo-13@gated-at.bofh.it> <jXVLH-7kO-5@gated-at.bofh.it> <jXW53-7CC-5@gated-at.bofh.it> <jXWeJ-7Lk-1@gated-at.bofh.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Nix <nix@esperi.org.uk>, linux-ext4@vger.kernel.org, tytso@mit.edu,
	stable@vger.kernel.org, gregkh@linuxfoundation.org
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <jXWeJ-7Lk-1@gated-at.bofh.it>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 10/24/2012 01:40 AM, Nix wrote:

> It's true that in less than a week
> probably not all that many people have rebooted often enough to trip
> over this.
>
> I hope.
>

Fwiw, i got a fried root filesystem (ext4) on one machine last week. It 
was on 3.5.3 or 3.5.5. Since there was nothing in the logs and the 
kernel was modified (CK, BFQ) and tainted (nvidia) I did not notify any 
maintainers. I have not had the time yet to rebuild the machine 
(unfortunately that will be laboursome), so the users cannot do their 
homework or attend to their social life for the time being...

The pattern was indeed characterized by a sequence of reboots (I am 
told), and in a weird fashion files started to disappear from the root 
filesystem (I first noticed /etc/groups missing, and after further fscks 
and reboots login became impossible (I assume that /etc/passwd and or 
/etc/shadow are buggered). I haven't assessed the extent of the damage yet.

Still not sure whether it is related to the bug in question, of course.

Martin
