From: Eric Sandeen <esandeen@redhat.com>
Subject: Re: e2fsck and backup superblocks
Date: Sun, 19 Feb 2012 22:11:12 -0500 (EST)
Message-ID: <B2C249E4-41BE-400F-BC11-B1F7ABDE308E@redhat.com>
References: <4F3F1439.5000407@ubuntu.com> <4F3F1580.9020108@redhat.com> <20120218223131.GB8320@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Eric Sandeen <sandeen@redhat.com>, Phillip Susi <psusi@ubuntu.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx4-phx2.redhat.com ([209.132.183.25]:60772 "EHLO
	mx4-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751356Ab2BTDLP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 19 Feb 2012 22:11:15 -0500
In-Reply-To: <20120218223131.GB8320@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Feb 18, 2012, at 4:31 PM, "Ted Ts'o" <tytso@mit.edu> wrote:

> On Fri, Feb 17, 2012 at 07:05:36PM -0800, Eric Sandeen wrote:
>> -----BEGIN PGP SIGNED MESSAGE-----
>> Hash: SHA1
>> 
>> On 2/17/12 7:00 PM, Phillip Susi wrote:
>>> I have noticed that e2fsck always complains about block group descriptor checksums being invalid when run on a backup superblock, even when run again immediately after being told to fix them.  Is there some odd intentional behavior here I'm not aware of?
>> 
>> Check the list for:
>> 
>> "[PATCH] libext2fs: quiet spurious group checksum errors"
> 
> Which is in e2fsprogs 1.42.1....
> 
Was that the release announcement?  :)

- Eric

>                                                  - Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

