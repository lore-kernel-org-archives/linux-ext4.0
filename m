From: Stuart Pook <slp4725@pook.it>
Subject: Re: error ext4_mb_generate_buddy:726 & add_dirent_to_buf:1272 after
 online resize
Date: Sun, 16 Jan 2011 15:28:53 +0100
Message-ID: <4D3300A5.1090300@pook.it>
References: <S1752440Ab1APNtL/20110116134911Z+826@vger.kernel.org> <4D32FACD.7020907@pook.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp6-g21.free.fr ([212.27.42.6]:32827 "EHLO smtp6-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753157Ab1APO3C (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 16 Jan 2011 09:29:02 -0500
Received: from shiva (unknown [88.171.134.228])
	by smtp6-g21.free.fr (Postfix) with ESMTP id 8718382286
	for <linux-ext4@vger.kernel.org>; Sun, 16 Jan 2011 15:28:56 +0100 (CET)
In-Reply-To: <4D32FACD.7020907@pook.it>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I forgot to mention: I am now running kooka 2.6.37-trunk-amd64 but when I resized the filesystem and started getting the errors I was running linux-image-2.6.37-rc5-amd64.
