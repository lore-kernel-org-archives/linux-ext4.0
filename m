Return-Path: <SRS0=3UD1=RY=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C866C43381
	for <linux-ext4@archiver.kernel.org>; Thu, 21 Mar 2019 22:08:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6FA4B21874
	for <linux-ext4@archiver.kernel.org>; Thu, 21 Mar 2019 22:08:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726897AbfCUWIc (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 21 Mar 2019 18:08:32 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:57203 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726374AbfCUWIb (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 21 Mar 2019 18:08:31 -0400
Received: from callcc.thunk.org (guestnat-104-133-0-99.corp.google.com [104.133.0.99] (may be forged))
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id x2LM8JWi027209
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Mar 2019 18:08:20 -0400
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id 67D2B420AA8; Thu, 21 Mar 2019 18:08:19 -0400 (EDT)
Date:   Thu, 21 Mar 2019 18:08:19 -0400
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Lukas Czerner <lczerner@redhat.com>
Cc:     Ext4 Developers List <linux-ext4@vger.kernel.org>,
        darrick.wong@oracle.com
Subject: Re: [PATCH 8/9] e2scrub_all: refactor device probe loop
Message-ID: <20190321220819.GL9434@mit.edu>
References: <20190321020218.5154-1-tytso@mit.edu>
 <20190321020218.5154-8-tytso@mit.edu>
 <20190321102742.k2oos4epoj6fyjao@work>
 <20190321143141.GB9434@mit.edu>
 <20190321155703.ili5ghofgm3hneq5@work>
 <20190321182456.GG9434@mit.edu>
 <20190321201710.vw5g2kfp6p2b3jxk@work>
 <20190321204823.GJ9434@mit.edu>
 <20190321220440.GK9434@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190321220440.GK9434@mit.edu>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Thu, Mar 21, 2019 at 06:04:40PM -0400, Theodore Ts'o wrote:
> OK, I've reworked the function to read:
> 
> ls_scan_targets() {
> 	lsblk -o NAME,MOUNTPOINT,FSTYPE -P -n -p \
> 	      $(lvs -o lv_path --noheadings -S "lv_active=active,lv_role=public,lv_role!=snapshot,vg_free>${snap_size_mb}") | \
> 	    grep FSTYPE=\"ext\[234\]\" | while read vars ; do
> 		eval "${vars}"
> 
> 		if [ "${scrub_all}" -eq 1 ] || [ -n "${MOUNTPOINT}" ]; then
> 		    echo ${MOUNTPOINT:-${NAME}}
> 		fi
> 	done | sort | uniq
> }
> 
> I think that's the final answer....

And I just saw your e-mail about dropping the sort and uniq calls.
OK, I'll take care of that too.

					- Ted
					
