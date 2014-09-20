From: TR Reardon <thomas_reardon@hotmail.com>
Subject: resize2fs problem with stride calc
Date: Sat, 20 Sep 2014 16:46:36 -0400
Message-ID: <BAY179-W85AF983234DB78F07A12EFDB50@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
To: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bay004-omc1s24.hotmail.com ([65.54.190.35]:63453 "EHLO
	BAY004-OMC1S24.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756723AbaITUqh convert rfc822-to-8bit
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 20 Sep 2014 16:46:37 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

resize2fs seems to come up with some crazy default stride numbers.  This occurs with and without bigalloc.


I was testing enabling/disabling 64bit using latest patches from DJW, and noticed that s_raid_stride was being written with nonsensical values, in particular determine_fs_stride() is coming up with overly large values.  The code is old (2006) and lacks comment so I'm not sure what the intended operation is.  Does this just need to be updated for flex_bg?  Should s_raid_stride ever be auto-changed on resize?  If it should change, should stripe also change?

+Reardon 		 	   		  