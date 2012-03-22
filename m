From: Andreas Dilger <adilger@whamcloud.com>
Subject: Re: [PATCH 4/4] ext4: enable online-resizing support meta_bg and bit64
Date: Thu, 22 Mar 2012 10:00:29 -0600
Message-ID: <7B60D761-BBEC-48A6-906B-4DD0666897E4@whamcloud.com>
References: <1327852866-4448-1-git-send-email-xiaoqiangnk@gmail.com> <1327852866-4448-5-git-send-email-xiaoqiangnk@gmail.com>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"adilger@gmail.com" <adilger@gmail.com>,
	Yongqiang Yang <xiaoqiangnk@gmail.com>
To: Yongqiang Yang <xiaoqiangnk@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:48856 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030665Ab2CVP7z (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 22 Mar 2012 11:59:55 -0400
Received: by yhmm54 with SMTP id m54so1864854yhm.19
        for <linux-ext4@vger.kernel.org>; Thu, 22 Mar 2012 08:59:54 -0700 (PDT)
In-Reply-To: <1327852866-4448-5-git-send-email-xiaoqiangnk@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2012-01-29, at 10:01, Yongqiang Yang <xiaoqiangnk@gmail.com> wrote:

> This patch let online-resizing support meta_bg and bit64 features.

The description and summary should say "64bit" instead of "bit64". 

Cheers, Andreas
