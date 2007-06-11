From: "Jose R. Santos" <jrs@us.ibm.com>
Subject: Re: [RFC][PATCH 4/12] convert some block types in e2fsprogs
Date: Mon, 11 Jun 2007 15:59:30 -0500
Message-ID: <20070611155930.0bbcccbf@gara>
References: <466D7B74.5000207@bull.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Theodore Tso <tytso@mit.edu>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Valerie Clement <valerie.clement@bull.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.152]:45168 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751251AbXFKVAA (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 11 Jun 2007 17:00:00 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e34.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id l5BL00En014893
	for <linux-ext4@vger.kernel.org>; Mon, 11 Jun 2007 17:00:00 -0400
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l5BKxuCm263868
	for <linux-ext4@vger.kernel.org>; Mon, 11 Jun 2007 15:00:00 -0600
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l5BKxu16025366
	for <linux-ext4@vger.kernel.org>; Mon, 11 Jun 2007 14:59:56 -0600
In-Reply-To: <466D7B74.5000207@bull.net>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, 11 Jun 2007 18:42:28 +0200
Valerie Clement <valerie.clement@bull.net> wrote:

> This patch converts some int or unsigned int block number definitions
> to blk_t type.  Most conversions are necessary for 64-bit porting.

What about unsigned long?  There are various places where block is
represented by using unsigned long which is 32-bit when running 32 bit
binaries. Most PPC64 distributions compile their user-space tools in
32-bit binaries.

I wonder how badly it will break.

-JRS
