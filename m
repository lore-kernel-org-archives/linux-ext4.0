Return-Path: <linux-ext4-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D66C2C7EE24
	for <linux-ext4@archiver.kernel.org>; Sat,  6 May 2023 05:56:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230271AbjEFF4E (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Sat, 6 May 2023 01:56:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230221AbjEFF4D (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sat, 6 May 2023 01:56:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60F1F4C00;
        Fri,  5 May 2023 22:56:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A552C6162F;
        Sat,  6 May 2023 05:56:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1AE4C433EF;
        Sat,  6 May 2023 05:55:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1683352561;
        bh=PjYU7Vj5zkKrWTgj66rJEkfUelQO0WdYPeuo6VDLIv4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jZfZFK2Ci7SQtzBdtZvtDhoZx3sOQOrUKzCPx36N+mbodD1OiSOHz3N9vvPBugzIx
         cQEQFfW8IkyK7p7YZn6r7Koy6SSEclESy30eC78fj9iSdk2Ie5Mqc0fmRUms3D++HP
         FQvfbN2Z9xI2V6F6ANlShOA0VWJIf4qtZ3xGETo8=
Date:   Sat, 6 May 2023 11:09:36 +0900
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jan Kara <jack@suse.cz>
Cc:     stable@vger.kernel.org, Ted Tso <tytso@mit.edu>,
        linux-ext4@vger.kernel.org
Subject: Re: Pick commit 2729cfdcfa ("ext4: use ext4_journal_start/stop for
 fast commit transactions")
Message-ID: <2023050626-plaster-heavily-cbc3@gregkh>
References: <20230427162459.qb3tnh3be6ofibzz@quack3>
 <2023042804-feed-radiantly-2a07@gregkh>
 <20230428120246.hzx6lhkvmfdspy75@quack3>
 <20230428145158.47qrmwrujo6giyif@quack3>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230428145158.47qrmwrujo6giyif@quack3>
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Fri, Apr 28, 2023 at 04:51:58PM +0200, Jan Kara wrote:
> On Fri 28-04-23 14:02:46, Jan Kara wrote:
> > > Can you send us backported, and tested, versions of this commit so that
> > > we can apply them?
> > 
> > Yeah, I'll look into applying the patch directly to stable branches.
> 
> Attached is backport of the fix to 5.10-stable kernel (passed xfstests run
> for ext4 with fast_commit enabled).

Thanks for both of these, now queued up.

greg k-h
