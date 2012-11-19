From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Issue with bad file system
Date: Mon, 19 Nov 2012 15:30:54 -0600
Message-ID: <50AAA50E.2070001@redhat.com>
References: <20121119211537.5429.qmail@science.horizon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: dreusser@gmail.com, linux-ext4@vger.kernel.org
To: George Spelvin <linux@horizon.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43666 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751851Ab2KSVbD (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 19 Nov 2012 16:31:03 -0500
In-Reply-To: <20121119211537.5429.qmail@science.horizon.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 11/19/12 3:15 PM, George Spelvin wrote:
>> There is no encryption to my knowledge (not an expert in mdadm).
> 
> linux md doesn't do encryption.  But there are other things, like
> dm-crypt, that it can be combined with to do encryption.
> 
> That doesn't look like a superblock, that looks like random bits,
> as produced by encryption or good compression.  (Could be jpeg,
> mp3, or compressed video, it's hard to tell.)

does blkid /dev/md0 and/or file -s /dev/md0 think it looks like anything other than data?

-Eric

