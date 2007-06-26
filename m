From: Girish Shilamkar <girish@clusterfs.com>
Subject: Re: performance testing
Date: Tue, 26 Jun 2007 16:06:51 +0530
Message-ID: <1182854211.3041.10.camel@dhcp7.linsyssoft.com>
References: <467BE4C0.2020203@bull.net>
	 <1182541578.9939.3.camel@localhost.localdomain>
	 <467C99F5.6060603@clusterfs.com>
	 <1182755567.4067.1.camel@localhost.localdomain> <467FE8A5.4030508@bull.net>
	 <467FEAF7.7060902@clusterfs.com> <4680CE9B.1030602@bull.net>
	 <4680E0FE.8080102@bull.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Alex Tomas <alex@clusterfs.com>,
	Andreas Dilger <adilger@clusterfs.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Valerie Clement <valerie.clement@bull.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:41402 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752109AbXFZKgf (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 26 Jun 2007 06:36:35 -0400
In-Reply-To: <4680E0FE.8080102@bull.net>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, 2007-06-26 at 11:48 +0200, Valerie Clement wrote:
> Shouldn't it be :
> 
>    struct commit_header *tmp = (struct commit_header*)(bh->b_data + i);
> 
Ohhh, yes you are right. This is the correct thing to do.
This patch which is been used has some endian-ness bugs. I had sent an
updated patch for 2.6.22-rc5 on 
19 June. I think we should be using the updated patch else it may break
on big-endian machines. 
Even the updated patch has this bug i.e "struct commit_header *tmp
=...."

Thanks,
Girish.
