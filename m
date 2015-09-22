From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: resize2fs stuck in ext4_group_extend with 100% CPU Utilization
 With Small Volumes
Date: Tue, 22 Sep 2015 18:41:16 -0500
Message-ID: <5601E71C.4080705@redhat.com>
References: <06724CF51D6BC94E9BEE7A8A8CB82A6740FE22BCBA@MX01A.corp.emc.com>
 <20150922202058.GB3318@thunk.org>
 <06724CF51D6BC94E9BEE7A8A8CB82A6740FE22BCDF@MX01A.corp.emc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: "Pocas, Jamie" <Jamie.Pocas@emc.com>,
	"Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44236 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758766AbbIVXlQ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 22 Sep 2015 19:41:16 -0400
In-Reply-To: <06724CF51D6BC94E9BEE7A8A8CB82A6740FE22BCDF@MX01A.corp.emc.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 9/22/15 4:26 PM, Pocas, Jamie wrote:
> Hi Theodore,
> 
> I am not sure if you had a chance to see my reply to Eric yet. I can
> see you are using the same general approach that Eric was using. The
> key difference from what I am doing again seems to be that I am
> resizing the underlying disk *while the filesystem is mounted*.

Do you see the same problem if you resize a physical disk, not
just with loopback? Sounds like it...

In theory it should be reproducible w/ lvm too, then, I think,
unless there's some issue specific to your block device similar to
what's happening on the loop device.

> Instead you both are using truncate to grow the disk while the
> filesystem is not currently mounted, and then mounting it.

Always worth communicating a testcase in the first email, if you
have one, so we don't have to guess.  ;)

thanks,
-Eric

