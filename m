From: Andreas Dilger <andreas.dilger@oracle.com>
Subject: Re: [PATCH 4/8] e2fsprogs: Next3 snapshot control with chattr/lsattr -X
Date: Mon, 21 Jun 2010 12:17:49 -0600
Message-ID: <1F7FAC7E-3FCF-4E32-922D-02E7A068CC50@oracle.com>
Mime-Version: 1.0 (Apple Message framework v1078)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: "linux-ext4@vger.kernel.org development" <linux-ext4@vger.kernel.org>
To: Amir Goldstein <amir73il@users.sf.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:65485 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753985Ab0FUSRu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 21 Jun 2010 14:17:50 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> +static struct flags_name snapshot_flags_array[] = {
> +	{ NEXT3_SNAPFILE_LIST_FL, "S", "on_liSt" },
> +	{ NEXT3_SNAPFILE_ENABLED_FL, "n", "eNabled" },
> +	{ NEXT3_SNAPFILE_ACTIVE_FL, "a", "Active" },
> +	{ NEXT3_SNAPFILE_INUSE_FL, "p", "inuse_by_Previous" },
> +	{ NEXT3_SNAPFILE_DELETED_FL, "s", "Deleted" },
> +	{ NEXT3_SNAPFILE_SHRUNK_FL, "h", "sHrunk" },
> +	{ NEXT3_SNAPFILE_OPEN_FL, "o", "mOunted" },
> +	{ NEXT3_SNAPFILE_TAGGED_FL, "t", "Tagged" },
>  	{ 0, NULL, NULL }
>  };

While clever, I don't think this necessarily makes for a good user interface.
In comparison, flags "l, e, a, i, d, s, m ,t" respectively make much easier to understand/remember name abbreviations.

Cheers, Andreas
--
Andreas Dilger
Lustre Technical Lead
Oracle Corporation Canada Inc.

