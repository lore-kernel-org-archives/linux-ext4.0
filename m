From: Roel Kluin <roel.kluin@gmail.com>
Subject: Re: ext4: buffer underrun in ext4_ext_split()?
Date: Fri, 07 Aug 2009 20:50:39 +0200
Message-ID: <4A7C777F.3030803@gmail.com>
References: <4A7C7045.7040704@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
To: Roel Kluin <roel.kluin@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ew0-f214.google.com ([209.85.219.214]:48425 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932740AbZHGSrE (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 7 Aug 2009 14:47:04 -0400
Received: by ewy10 with SMTP id 10so1741209ewy.37
        for <linux-ext4@vger.kernel.org>; Fri, 07 Aug 2009 11:47:03 -0700 (PDT)
In-Reply-To: <4A7C7045.7040704@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Op 07-08-09 20:19, Roel Kluin schreef:
> If `depth' is less or equal to `at', a buffer underrun occurs

s/underrun/overflow/g
