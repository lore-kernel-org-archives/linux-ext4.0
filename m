From: Thomas Kupper <thomas@kupper.org>
Subject: Re: mount ext2/3 as ext4 - no changes to ext2/3 fs structures?
Date: Wed, 3 Feb 2010 16:18:25 +0100
Message-ID: <0081ACB2-54C6-4AE5-B55F-CEAF299CFC7A@kupper.org>
References: <88FF0BDF-9F6F-4A2D-A236-C388BFFA145D@kupper.org> <532480951001312154g1c927b31xe0181cc301b5a28d@mail.gmail.com>
Mime-Version: 1.0 (Apple Message framework v1077)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: Michael Rubin <mrubin@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mxout002.mail.hostpoint.ch ([217.26.49.181]:57405 "EHLO
	mxout002.mail.hostpoint.ch" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755201Ab0BCPS2 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 3 Feb 2010 10:18:28 -0500
In-Reply-To: <532480951001312154g1c927b31xe0181cc301b5a28d@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 1 Feb 2010, at 06:54, Michael Rubin wrote:

> On Sun, Jan 31, 2010 at 2:31 PM, Thomas Kupper <thomas@kupper.org> wrote:
>> Consider the following scenario: Assume I have a partition formated with ext2 on a computer with some 2.4.x kernel. Now I mount this ext2 partition on another computer as ext4 using a 2.6.29+ kernel. After that I take the disk back to the older computer and mount the ext2 on the 2.4.x kernel with the ext2 driver.
> 
> I have seen this work as long as you don't add the "extents" or other
> ext4 specific mount options. Our kernels are not quite as up to date
> as 2.6.29 and we have not done extensive testing with that kernel. Not
> sure anyone has tested this case thoroughly.

Thanks alot for your answer, that'll do for me to start with. Nothing on computers is guaranteed to work perfect :)

> mrubin

Cheers,
Thomas