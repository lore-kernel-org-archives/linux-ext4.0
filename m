Return-Path: <SRS0=qwWH=3O=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02223C35241
	for <linux-ext4@archiver.kernel.org>; Sat, 25 Jan 2020 06:44:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D418C2071E
	for <linux-ext4@archiver.kernel.org>; Sat, 25 Jan 2020 06:44:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726145AbgAYGoD (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Sat, 25 Jan 2020 01:44:03 -0500
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:44468 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725781AbgAYGoD (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sat, 25 Jan 2020 01:44:03 -0500
Received: from callcc.thunk.org (rrcs-67-53-201-206.west.biz.rr.com [67.53.201.206])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 00P6hvlF017999
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 25 Jan 2020 01:43:59 -0500
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id A0DCD42014A; Sat, 25 Jan 2020 01:43:56 -0500 (EST)
Date:   Sat, 25 Jan 2020 01:43:56 -0500
From:   "Theodore Y. Ts'o" <tytso@mit.edu>
To:     Andreas Dilger <adilger@dilger.ca>
Cc:     linux-ext4@vger.kernel.org
Subject: Re: [PATCH 2/2] mmp: abstract out repeated 'sizeof(buf), buf' usage
Message-ID: <20200125064356.GB1108497@mit.edu>
References: <20191231220724.GA118765@mit.edu>
 <1579038138-49231-1-git-send-email-adilger@dilger.ca>
 <1579038138-49231-2-git-send-email-adilger@dilger.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1579038138-49231-2-git-send-email-adilger@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Tue, Jan 14, 2020 at 02:42:18PM -0700, Andreas Dilger wrote:
> The printf("%.*s") format requires both the buffer size and buffer
> pointer to be specified for each use.  Since this is repeatedly given
> as "(int)sizeof(buf), (char *)buf" for mmp_nodename and mmp_bdevname
> fields, with typecasts to avoid compiler warnings.
> 
> Add a helper macro EXT2_LEN_STR() to avoid repeated boilerplate code.
> 
> This can also be used for other superblock buffer fields that may not
> have NUL-terminated strings (e.g. s_volume_name, s_last_mounted,
> s_{first,last}_error_func, s_mount_opts) to simplify code and avoid
> the need for temporary buffers for NUL-termination.
> 
> Annotate the superblock string fields that may not be NUL-terminated.
> 
> Signed-off-by: Andreas Dilger <adilger@dilger.ca>

Applied, thanks.

						- Ted
