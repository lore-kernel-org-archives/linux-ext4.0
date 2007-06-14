From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [PATCH 4/6] add noversion mount option
Date: Thu, 14 Jun 2007 13:50:14 -0700
Message-ID: <1181854214.3883.10.camel@dyn9047017103.beaverton.ibm.com>
References: <1181835073.7779.9.camel@garfield>
	 <1181836579.7779.46.camel@garfield>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-ext4 <linux-ext4@vger.kernel.org>,
	Andreas Dilger <adilger@clusterfs.com>,
	Jean noel Cordenner <jean-noel.cordenner@bull.net>
To: Kalpak Shah <kalpak@clusterfs.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.151]:39800 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755132AbXFNUuR (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 14 Jun 2007 16:50:17 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e33.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id l5EKoGaT009665
	for <linux-ext4@vger.kernel.org>; Thu, 14 Jun 2007 16:50:16 -0400
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l5EKoGWg266872
	for <linux-ext4@vger.kernel.org>; Thu, 14 Jun 2007 14:50:16 -0600
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l5EKoG6e000484
	for <linux-ext4@vger.kernel.org>; Thu, 14 Jun 2007 14:50:16 -0600
In-Reply-To: <1181836579.7779.46.camel@garfield>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, 2007-06-14 at 21:26 +0530, Kalpak Shah wrote:
> This patch adds a "noversion" mount option to disable inode version
> updates.

Can you explain a bit more why we need this mount option? Is it because
of performance concern? 

Mingming
