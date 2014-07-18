From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: Question about e2fsprogs/e4defrag
Date: Thu, 17 Jul 2014 20:05:46 -0600
Message-ID: <B641A278-9C28-4B1A-9C6F-400722EAB353@dilger.ca>
References: <53C5FCA5.20207@cn.fujitsu.com> <20140716192236.GA8628@birch.djwong.org> <53C74316.1050902@cn.fujitsu.com> <20140717180908.GB8628@birch.djwong.org>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"a-fujita@rs.jp.nec.com" <a-fujita@rs.jp.nec.com>,
	"t-sato@yk.jp.nec.com" <t-sato@yk.jp.nec.com>
To: Xiaoguang Wang <wangxg.fnst@cn.fujitsu.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f43.google.com ([209.85.220.43]:64987 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752976AbaGRCFt (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 17 Jul 2014 22:05:49 -0400
Received: by mail-pa0-f43.google.com with SMTP id lf10so4452200pab.30
        for <linux-ext4@vger.kernel.org>; Thu, 17 Jul 2014 19:05:47 -0700 (PDT)
In-Reply-To: <20140717180908.GB8628@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This thread for me to thinking that it would be useful if filefrag also
printed the "fragmentation score" that e4defrag prints that would make
It more clear whether a file should be considered "fragmented" or not,
and it helps the user to decide if e4defrag should be run on it. 

I'm not sure whether this is always printed or only with an option. 

Cheers, Andreas
