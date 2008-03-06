From: "Duane Griffin" <duaneg@dghda.com>
Subject: Re: [RFC, PATCH 0/6] ext3: do not modify data on-disk when mounting read-only filesystem
Date: Thu, 6 Mar 2008 11:20:39 +0000
Message-ID: <e9e943910803060320o1992b488h799218cafc5a02be@mail.gmail.com>
References: <1204768754-29655-1-git-send-email-duaneg@dghda.com>
	 <20080305194220.f9cce55e.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	"Theodore Tso" <tytso@mit.edu>, sct@redhat.com,
	adilger@clusterfs.com
To: "Andrew Morton" <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.172]:10157 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758693AbYCFLUl (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 6 Mar 2008 06:20:41 -0500
Received: by wf-out-1314.google.com with SMTP id 28so2477175wff.4
        for <linux-ext4@vger.kernel.org>; Thu, 06 Mar 2008 03:20:40 -0800 (PST)
In-Reply-To: <20080305194220.f9cce55e.akpm@linux-foundation.org>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 06/03/2008, Andrew Morton <akpm@linux-foundation.org> wrote:
> I'll grab the first three for now, thanks.

Great, thanks!

> Someone(tm) should do the jbd2 versions..

I'll do them tonight, unless someone beats me to it.

Cheers,
Duane.

-- 
"I never could learn to drink that blood and call it wine" - Bob Dylan
