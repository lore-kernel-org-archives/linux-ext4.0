Return-Path: <SRS0=2wuY=SI=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D260C10F06
	for <linux-ext4@archiver.kernel.org>; Sat,  6 Apr 2019 20:47:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2B81421019
	for <linux-ext4@archiver.kernel.org>; Sat,  6 Apr 2019 20:47:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726184AbfDFUrR (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Sat, 6 Apr 2019 16:47:17 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:39010 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726031AbfDFUrR (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sat, 6 Apr 2019 16:47:17 -0400
Received: from callcc.thunk.org (153.sub-174-209-24.myvzw.com [174.209.24.153])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id x36Kkdjp007445
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 6 Apr 2019 16:46:42 -0400
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id B5361421A06; Sat,  6 Apr 2019 15:53:42 -0400 (EDT)
Date:   Sat, 6 Apr 2019 15:53:42 -0400
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Gabriel Krisman Bertazi <krisman@collabora.com>
Cc:     linux-ext4@vger.kernel.org, sfrench@samba.org,
        darrick.wong@oracle.com, jlayton@kernel.org, bfields@fieldses.org,
        paulus@samba.org, linux-fsdevel@vger.kernel.org,
        Olaf Weber <olaf@sgi.com>,
        Gabriel Krisman Bertazi <krisman@collabora.co.uk>
Subject: Re: [PATCH RFC v6 04/11] unicode: reduce the size of utf8data[]
Message-ID: <20190406195342.GA18897@mit.edu>
References: <20190318202745.5200-1-krisman@collabora.com>
 <20190318202745.5200-5-krisman@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190318202745.5200-5-krisman@collabora.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Mon, Mar 18, 2019 at 04:27:38PM -0400, Gabriel Krisman Bertazi wrote:
> From: Olaf Weber <olaf@sgi.com>
> 
> Remove the Hangul decompositions from the utf8data trie, and do
> algorithmic decomposition to calculate them on the fly. To store
> the decomposition the caller of utf8lookup()/utf8nlookup() must
> provide a 12-byte buffer, which is used to synthesize a leaf with
> the decomposition. Trie size is reduced from 245kB to 90kB.

I'm seeing sizes much smaller; the actual utf8data[] array is 63,584.
And size utf8-norm.o reports:

   text	   data	    bss	    dec	    hex	filename
  68752	     96	      0	  68848	  10cf0	fs/unicode/utf8-norm.o

Were you measuring the size of the utf8-norm.o file?  That will vary
in size depending on whether debugging symbols are enabled, etc.

   		     	     	       	       - Ted
