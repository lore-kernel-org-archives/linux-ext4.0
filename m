From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: debugfs fill_bgs command?
Date: Wed, 11 Apr 2007 20:21:56 -0500
Message-ID: <461D89B4.5000103@redhat.com>
References: <461D4256.6020509@redhat.com> <20070411225237.GH5967@schatzie.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@clusterfs.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:51865 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161442AbXDLBW2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 11 Apr 2007 21:22:28 -0400
In-Reply-To: <20070411225237.GH5967@schatzie.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Andreas Dilger wrote:

> Try "mke2fs -O lazy_bg XXX" and be happy.  Can be used on any kernel as
> it is a COMPAT feature and marks all but first and last groups as full.

Ugh, how'd I miss that.  :)

Thanks...

-Eric
