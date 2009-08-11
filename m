From: Al Boldi <a1426z@gawab.com>
Subject: Re: [PATCH, RFC] ext3: Update Kconfig description of EXT3_DEFAULTS_TO_ORDERED
Date: Tue, 11 Aug 2009 06:49:20 +0300
Message-ID: <200908110649.20277.a1426z@gawab.com>
References: <1249934623-15939-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
	Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>, Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailhost13.gawab.com ([66.220.20.13]:42767 "HELO
	info15.gawab.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754400AbZHKMtB (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 11 Aug 2009 08:49:01 -0400
In-Reply-To: <1249934623-15939-1-git-send-email-tytso@mit.edu>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Ts'o wrote:
> +	  "data=ordered" mode can also result in major performance
> +	  problems, including seconds-long delays before an fsync()
> +	  call returns.	 For details, see:
> +
> +	  http://ext4.wiki.kernel.org/index.php/Ext3_data_mode_tradeoffs

Why isn't the fsync problem fixable?


Thanks!

--
Al

