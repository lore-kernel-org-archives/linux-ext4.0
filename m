From: Daniel Phillips <phillips@phunq.net>
Subject: Re: [PATCH,RFC] ext3: Add support for non-native signed/unsigned htree hash algorithms
Date: Tue, 21 Oct 2008 14:53:11 -0700
Message-ID: <200810211453.11194.phillips@phunq.net>
References: <1224560624-9691-1-git-send-email-tytso@mit.edu> <1224560624-9691-2-git-send-email-tytso@mit.edu> <200810211450.59184.phillips@phunq.net>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	akpm@linux-foundation.org, linux-kernel@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from phunq.net ([64.81.85.152]:42813 "EHLO moonbase.phunq.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750966AbYJUVxT (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 21 Oct 2008 17:53:19 -0400
In-Reply-To: <200810211450.59184.phillips@phunq.net>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Excuse me,

> +static __u32 uchar_hack_hash (const char *name, int len)

I meant:

+static __u32 uchar_hack_hash(const unsigned char *name, int len)

Regards

Daniel
