From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Corrupted superblock? But disk still mounts.
Date: Mon, 18 Aug 2014 13:37:09 -0500
Message-ID: <53F247D5.4030502@redhat.com>
References: <CAMJSjjuRj5-VNs0TeoMEvrozyeJVQH+BUxsBaqO07WH9eKD88w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
To: Mark Ballard <markjballard@googlemail.com>,
	linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:29562 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751860AbaHRShO (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 18 Aug 2014 14:37:14 -0400
In-Reply-To: <CAMJSjjuRj5-VNs0TeoMEvrozyeJVQH+BUxsBaqO07WH9eKD88w@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 8/18/14, 1:14 PM, Mark Ballard wrote:
> Found bad superblock when trying to rename partition using e2label.
> 
> The same problem has prevented me using dumpe2fs, e2fsck and fsck to
> try and resolve the problem.
> 
> But I can still mount the disk and use it.
> 
> The disk is encrypted.

How is /dev/sdb1 encrypted?  Usually this is done with something like dm-crypt.
Or is it hardware encryption managed in the bios?  Did you unlock it?

What does "blkid /dev/sdb1" say?

I'm guessing that it's the encryption getting in your way.

-Eric
