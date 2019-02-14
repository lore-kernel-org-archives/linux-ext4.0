Return-Path: <SRS0=5TFS=QV=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A604FC43381
	for <linux-ext4@archiver.kernel.org>; Thu, 14 Feb 2019 13:46:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 74521222B6
	for <linux-ext4@archiver.kernel.org>; Thu, 14 Feb 2019 13:46:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1550151997;
	bh=9VFACCoGzLjG/ySkIt88r3vgcVlkdUz8JenhZuiLfuQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=nvTNu+pqZYBSMojrivBGrcehVIhuts+u28Uwd7LCjQPH6pBqjhlwhAu5tpvfF8yMR
	 /YOF4OMnMQA6Og3eJClqbOCeMslzUV6Gmzm2bJv8a7aWWSebdtx+LWsfsdvsqe/3RJ
	 PpgCQNC+ov9F+K/djWKwNWaRJ5+Z1cvWefDigY9w=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394768AbfBNNqZ (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 14 Feb 2019 08:46:25 -0500
Received: from mx2.suse.de ([195.135.220.15]:42914 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387759AbfBNNqY (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 14 Feb 2019 08:46:24 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 14C45AF9C;
        Thu, 14 Feb 2019 13:46:23 +0000 (UTC)
Date:   Thu, 14 Feb 2019 14:46:22 +0100
From:   Michal Hocko <mhocko@kernel.org>
To:     Dan Williams <dan.j.williams@intel.com>
Cc:     lsf-pc@lists.linux-foundation.org,
        linux-xfs <linux-xfs@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-ext4 <linux-ext4@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-nvdimm <linux-nvdimm@lists.01.org>
Subject: Re: [Lsf-pc] [LSF/MM TOPIC] The end of the DAX experiment
Message-ID: <20190214134622.GG4525@dhcp22.suse.cz>
References: <CAPcyv4jyCDJTpGZB6qVX7_FiaxJfDzWA1cw8dfPjHM2j3j3yqQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPcyv4jyCDJTpGZB6qVX7_FiaxJfDzWA1cw8dfPjHM2j3j3yqQ@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Wed 06-02-19 13:12:59, Dan Williams wrote:
[...]
> * Userfaultfd for file-backed mappings and DAX

I assume that other topics are meant to be FS track but this one is MM,
right?

-- 
Michal Hocko
SUSE Labs
