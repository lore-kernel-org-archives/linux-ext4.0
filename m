Return-Path: <SRS0=gd00=QI=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A0F9C282D8
	for <linux-ext4@archiver.kernel.org>; Fri,  1 Feb 2019 18:59:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DCA0A21872
	for <linux-ext4@archiver.kernel.org>; Fri,  1 Feb 2019 18:59:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="rR9Uk2mp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729558AbfBAS7y (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Fri, 1 Feb 2019 13:59:54 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:54690 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727450AbfBAS7y (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 1 Feb 2019 13:59:54 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id x11IxFiD191097;
        Fri, 1 Feb 2019 18:59:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=Hgiw8pSubO0/bdJMWSTv0jQrE2otRqKOF5fbwqE90FE=;
 b=rR9Uk2mpBC9/ApEU0ISgbKFptwDguOb1YzN8h6XXNpKV072Y0cHIPAel8HRMGq7D2Lma
 MIFR5bvFlROMYEZuYTnI6gmcRYg+Pa4hKFRulTG9VC7Aja4ZUQjvOFpOIek00is3xGwY
 NpMcPRO0mcu9XUCiGZVeZckJeJ+ja5V0nsx2gPjp7dMUKGR2VuHCXaifKBcwVqQ+6rw9
 e42pCytugS9AtbH6UjIMWt9xBLsc9GZOK3mYhlWbSZK8DriieruFhfLKBixIGy+oucO/
 nEbEKxrOTi7GVSLNUM1ipPU7Qx7MqiV5MJfx9pgCIAnLq6xfvHT7+6X8xb9eMYcL/3H8 fQ== 
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp2120.oracle.com with ESMTP id 2q8g6rr97y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 01 Feb 2019 18:59:52 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id x11IxpaC014092
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 1 Feb 2019 18:59:51 GMT
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x11Ixpve002804;
        Fri, 1 Feb 2019 18:59:51 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 01 Feb 2019 10:59:51 -0800
Date:   Fri, 1 Feb 2019 10:59:50 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Ross Burton <ross.burton@intel.com>
Cc:     linux-ext4@vger.kernel.org
Subject: Re: [PATCH v2] create_inode: fix copying large files
Message-ID: <20190201185950.GC10211@magnolia>
References: <20190201183247.8148-1-ross.burton@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190201183247.8148-1-ross.burton@intel.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9154 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1902010140
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Fri, Feb 01, 2019 at 06:32:47PM +0000, Ross Burton wrote:
> When copying large files into a ext filesystem at mkfs time the copy fails at
> 2^31 bytes in.  There are two problems:
> 
> copy_file_chunk() passes an offset (off_t, 64-bit typically) to
> ext2fs_file_lseek() which expects a ext2_off_t (typedef to __u32) so the value
> is truncated. Solve by calling ext2fs_file_llseek() which takes a u64 offset
> instead.
> 
> try_lseek_copy() rounds the data and hole offsets as found by lseek() to block
> boundaries, but the calculation gets truncated to 32-bits.  Solve by casting the
> 32-bit blocksize to off_t to ensure this doesn't happen.
> 
> Signed-off-by: Ross Burton <ross.burton@intel.com>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  misc/create_inode.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/misc/create_inode.c b/misc/create_inode.c
> index 05aa6363..1b35c769 100644
> --- a/misc/create_inode.c
> +++ b/misc/create_inode.c
> @@ -438,7 +438,7 @@ static errcode_t copy_file_chunk(ext2_filsys fs, int fd, ext2_file_t e2_file,
>  				ptr += blen;
>  				continue;
>  			}
> -			err = ext2fs_file_lseek(e2_file, off + bpos,
> +			err = ext2fs_file_llseek(e2_file, off + bpos,
>  						EXT2_SEEK_SET, NULL);
>  			if (err)
>  				goto fail;
> @@ -480,8 +480,8 @@ static errcode_t try_lseek_copy(ext2_filsys fs, int fd, struct stat *statbuf,
>  		if (hole < 0)
>  			return EXT2_ET_UNIMPLEMENTED;
>  
> -		data_blk = data & ~(fs->blocksize - 1);
> -		hole_blk = (hole + (fs->blocksize - 1)) & ~(fs->blocksize - 1);
> +		data_blk = data & ~(off_t)(fs->blocksize - 1);
> +		hole_blk = (hole + (off_t)(fs->blocksize - 1)) & ~(off_t)(fs->blocksize - 1);
>  		err = copy_file_chunk(fs, fd, e2_file, data_blk, hole_blk, buf,
>  				      zerobuf);
>  		if (err)
> -- 
> 2.11.0
> 
