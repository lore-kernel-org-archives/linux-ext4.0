From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: corruption on 3.1.0-rc9-next-20111011+
Date: Mon, 17 Oct 2011 11:10:36 +0300
Message-ID: <20111017081036.GN30887@longonot.mountain>
References: <20111017065700.GO18470@longonot.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:65360 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752740Ab1JQIOH (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 17 Oct 2011 04:14:07 -0400
Received: from acsinet21.oracle.com (acsinet21.oracle.com [141.146.126.237])
	by acsinet15.oracle.com (Switch-3.4.4/Switch-3.4.4) with ESMTP id p9H8E4uF018640
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Mon, 17 Oct 2011 08:14:06 GMT
Received: from acsmt358.oracle.com (acsmt358.oracle.com [141.146.40.158])
	by acsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id p9H8E4P6025239
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Mon, 17 Oct 2011 08:14:04 GMT
Received: from abhmt101.oracle.com (abhmt101.oracle.com [141.146.116.53])
	by acsmt358.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id p9H8Dxp7007001
	for <linux-ext4@vger.kernel.org>; Mon, 17 Oct 2011 03:13:59 -0500
Content-Disposition: inline
In-Reply-To: <20111017065700.GO18470@longonot.mountain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Oct 17, 2011 at 09:57:00AM +0300, Dan Carpenter wrote:
> Hi list,
> 
> I hit a sanity check in ext4_ext_insert_index() and my filesystem
> went read only.
> 

Hm...  That's odd.  My netbook hit the same bug last night as well.
It's running the same kernel version and config but compiled on a
different system.  I don't know why it has the '+' char on the end of
the version name.  Maybe it always does that for linux-next, because
I don't have any patches applied.

I've left it with the readonly filesystem for now.

regards,
dan carpenter
