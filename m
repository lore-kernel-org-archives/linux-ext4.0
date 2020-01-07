Return-Path: <SRS0=zmh8=24=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F3BAC33C8C
	for <linux-ext4@archiver.kernel.org>; Tue,  7 Jan 2020 17:11:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3AA182073D
	for <linux-ext4@archiver.kernel.org>; Tue,  7 Jan 2020 17:11:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728504AbgAGRL2 (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Tue, 7 Jan 2020 12:11:28 -0500
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:54267 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728503AbgAGRL1 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 7 Jan 2020 12:11:27 -0500
Received: from callcc.thunk.org (guestnat-104-133-0-111.corp.google.com [104.133.0.111] (may be forged))
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 007HBAi5008204
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 7 Jan 2020 12:11:11 -0500
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id EFF6E4207DF; Tue,  7 Jan 2020 12:11:09 -0500 (EST)
Date:   Tue, 7 Jan 2020 12:11:09 -0500
From:   "Theodore Y. Ts'o" <tytso@mit.edu>
To:     Jan Kara <jack@suse.cz>
Cc:     Ritesh Harjani <riteshh@linux.ibm.com>,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        Ext4 Developers List <linux-ext4@vger.kernel.org>,
        joseph.qi@linux.alibaba.com, Liu Bo <bo.liu@linux.alibaba.com>
Subject: Re: Discussion: is it time to remove dioread_nolock?
Message-ID: <20200107171109.GB3619@mit.edu>
References: <20191226153118.GA17237@mit.edu>
 <9042a8f4-985a-fc83-c059-241c9440200c@linux.alibaba.com>
 <20200106122457.A10F7AE053@d06av26.portsmouth.uk.ibm.com>
 <20200107004338.GB125832@mit.edu>
 <20200107082212.GA25547@quack2.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200107082212.GA25547@quack2.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Hmm..... There's actually an even more radical option we could use,
given that Ritesh has made dioread_nolock work on block sizes < page
size.  We could make dioread_nolock the default, until we can revamp
ext4_writepages() to write the data blocks first....

		     	       	    - Ted
				    
