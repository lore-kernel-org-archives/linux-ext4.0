From: Michael Rubin <mrubin@google.com>
Subject: Re: mount ext2/3 as ext4 - no changes to ext2/3 fs structures?
Date: Sun, 31 Jan 2010 21:54:27 -0800
Message-ID: <532480951001312154g1c927b31xe0181cc301b5a28d@mail.gmail.com>
References: <88FF0BDF-9F6F-4A2D-A236-C388BFFA145D@kupper.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: Thomas Kupper <thomas@kupper.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:58465 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754186Ab0BAFyu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 1 Feb 2010 00:54:50 -0500
Received: from kpbe19.cbf.corp.google.com (kpbe19.cbf.corp.google.com [172.25.105.83])
	by smtp-out.google.com with ESMTP id o115smQY014156
	for <linux-ext4@vger.kernel.org>; Sun, 31 Jan 2010 21:54:48 -0800
Received: from qyk5 (qyk5.prod.google.com [10.241.83.133])
	by kpbe19.cbf.corp.google.com with ESMTP id o115sl6P004437
	for <linux-ext4@vger.kernel.org>; Sun, 31 Jan 2010 21:54:47 -0800
Received: by qyk5 with SMTP id 5so2405021qyk.8
        for <linux-ext4@vger.kernel.org>; Sun, 31 Jan 2010 21:54:47 -0800 (PST)
In-Reply-To: <88FF0BDF-9F6F-4A2D-A236-C388BFFA145D@kupper.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Jan 31, 2010 at 2:31 PM, Thomas Kupper <thomas@kupper.org> wrote:
> Consider the following scenario: Assume I have a partition formated with ext2 on a computer with some 2.4.x kernel. Now I mount this ext2 partition on another computer as ext4 using a 2.6.29+ kernel. After that I take the disk back to the older computer and mount the ext2 on the 2.4.x kernel with the ext2 driver.

I have seen this work as long as you don't add the "extents" or other
ext4 specific mount options. Our kernels are not quite as up to date
as 2.6.29 and we have not done extensive testing with that kernel. Not
sure anyone has tested this case thoroughly.


mrubin
