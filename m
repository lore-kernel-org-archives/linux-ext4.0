From: "Jose R. Santos" <jrs@us.ibm.com>
Subject: Re: ext4 volume > 16TB possible?
Date: Tue, 8 Apr 2008 09:20:01 -0500
Message-ID: <20080408092001.203605fd@gara.konoha.net>
References: <20080407210237.GO23213@ifa.hawaii.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Joshua Hoblitt <jhoblitt@ifa.hawaii.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.150]:36782 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752472AbYDHOUP (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 8 Apr 2008 10:20:15 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e32.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id m38EIH2J010426
	for <linux-ext4@vger.kernel.org>; Tue, 8 Apr 2008 10:18:17 -0400
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m38EKFxV218576
	for <linux-ext4@vger.kernel.org>; Tue, 8 Apr 2008 08:20:15 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m38EKEVf018728
	for <linux-ext4@vger.kernel.org>; Tue, 8 Apr 2008 08:20:15 -0600
In-Reply-To: <20080407210237.GO23213@ifa.hawaii.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 7 Apr 2008 11:02:37 -1000
Joshua Hoblitt <jhoblitt@ifa.hawaii.edu> wrote:

> Hi Folks,
> 
> Is there as of yet a means of creating a large ext4 filesystem?  mke2fs
> as of 1.40.8 is still limited to creating ext3 filesystems at 16TB.

Support for 64-bit block number is not yet available on e2fsprogs.  It
is being worked on but other features currently have higher priority
that this so its hard to say when it will be done.

-JRS
