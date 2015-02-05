From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Bug in mount options handling in EXT4?
Date: Wed, 04 Feb 2015 22:52:59 -0600
Message-ID: <54D2F72B.2040408@redhat.com>
References: <alpine.LNX.2.03.1502050418390.11412@gmail.com> <54D2EA24.70206@redhat.com> <alpine.LNX.2.03.1502050525310.1476@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Enrico Mioso <mrkiko.rs@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.LNX.2.03.1502050525310.1476@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 2/4/15 10:26 PM, Enrico Mioso wrote:
> That's fine - as long as we can say that a possibly very very big of "nobarrier" options could be stored some place in memory and cause damage.
> Thank you for the reply and attention.
> Please - don't remove me from CC as I am not subscribed to any list.
> 
> Enrico

Hm, I see now that every "remount" extends the string, that wasn't quite clear from your first email (I thought you simply specified the same option multiple times):

> sudo mount -t ext4 -o rw,noatime,nobarrier,nobarrier,nobarrier, ... 

On my system, remounting with nobarrier a loop eventually fails with:

[mntent]: line 13 in /etc/mtab is bad; rest of file ignored
mount: can't find mnt in /etc/fstab or /etc/mtab

But that's not super graceful.  Anyway, this has a bit to do with how util-linux
manages /etc/mtab too, I guess.

On a system where /etc/mtab links to /proc/mounts, I don't see that behavior.

I do think that the length of the string copied from the user during mount (which is what's going on here) is properly sanitized in copy_mount_options().

-Eric
