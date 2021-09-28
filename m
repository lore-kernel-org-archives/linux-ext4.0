Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1BADC433F5
	for <linux-ext4@archiver.kernel.org>; Tue, 28 Sep 2021 02:49:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D4ED160F58
	for <linux-ext4@archiver.kernel.org>; Tue, 28 Sep 2021 02:49:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238712AbhI1CvT (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 27 Sep 2021 22:51:19 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:54573 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S238590AbhI1CvT (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 27 Sep 2021 22:51:19 -0400
Received: from cwcc.thunk.org (pool-72-74-133-215.bstnma.fios.verizon.net [72.74.133.215])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 18S2nUkn029126
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 27 Sep 2021 22:49:33 -0400
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id 76C6815C0098; Mon, 27 Sep 2021 22:49:30 -0400 (EDT)
Date:   Mon, 27 Sep 2021 22:49:30 -0400
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Andre Coelho <fc26887@alunos.fc.ul.pt>
Cc:     linux-ext4@vger.kernel.org
Subject: Re: fs ideas
Message-ID: <YVKCunMkd3O3zy78@mit.edu>
References: <5a0b3e05-d513-0d53-ee34-5d78f823f059@alunos.fc.ul.pt>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5a0b3e05-d513-0d53-ee34-5d78f823f059@alunos.fc.ul.pt>
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Mon, Sep 27, 2021 at 09:49:28PM +0100, Andre Coelho wrote:
> Hey, got some fs ideas , hope it helps. :) (if not ignore this :)). I just
> did in this in the remote change that this is helpful
> 
> https://drive.google.com/drive/folders/1QA0N93fLAFLf__9-cRNew8AgTUscQ0pl

It's not clear what your ideas are trying to accomplish.  It appears
to be related somehow to block allocation, but it's unclear what
on-disk or on-memory representation of which blocks are free or are in
use you are presuming.  When trying to express your ideas, it's best
if you first explain what you are trying to achieve, and how it is an
improvement over the current scheme, and then describe the data
structures (both on-disk and in-memory, if they are different) you are
proposing.

Cheers,

					- Ted
