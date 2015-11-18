From: "Elliott, Robert (Persistent Memory)" <elliott@hpe.com>
Subject: RE: [PATCH 3/9] ext4: Fix races between buffered IO and collapse /
 insert range
Date: Wed, 18 Nov 2015 01:39:37 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B40295BE2820A@G4W3202.americas.hpqcorp.net>
References: <1447185059-16166-1-git-send-email-jack@suse.com>
 <1447185059-16166-4-git-send-email-jack@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Ross Zwisler <ross.zwisler@linux.intel.com>,
	"dan.j.williams@intel.com" <dan.j.williams@intel.com>,
	"Boylston, Brian" <brian.boylston@hpe.com>
To: Jan Kara <jack@suse.com>, Ted Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from g4t3425.houston.hp.com ([15.201.208.53]:17346 "EHLO
	g4t3425.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752856AbbKRBla convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 17 Nov 2015 20:41:30 -0500
In-Reply-To: <1447185059-16166-4-git-send-email-jack@suse.com>
Content-Language: en-US
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


> -----Original Message-----
> From: linux-ext4-owner@vger.kernel.org [mailto:linux-ext4-
> owner@vger.kernel.org] On Behalf Of Jan Kara
> Sent: Tuesday, November 10, 2015 1:51 PM
> Subject: [PATCH 3/9] ext4: Fix races between buffered IO and collapse /
> insert range
> 
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
>  	/*
> -	 * Prevent page faults from reinstantiating pages we have released from
> +	 * Prevent page faults from reinstantiating we have released from
>  	 * page cache.

I don't think you meant to delete that word...


