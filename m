From: =?ISO-8859-1?Q?Cristian_Rodr=EDguez?= <crrodriguez@opensuse.org>
Subject: Re: [PATCH] lib/ext2fs/bitops.h: Use the optmized/documented byteswapping
 routines
Date: Mon, 14 Jan 2013 12:33:31 -0300
Message-ID: <50F4254B.9040102@opensuse.org>
References: <1358019145-2774-1-git-send-email-crrodriguez@opensuse.org> <20130114141356.GA12052@thunk.org> <20130114142005.GC12052@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-oa0-f43.google.com ([209.85.219.43]:59704 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756283Ab3ANPei (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 14 Jan 2013 10:34:38 -0500
Received: by mail-oa0-f43.google.com with SMTP id k1so4078164oag.2
        for <linux-ext4@vger.kernel.org>; Mon, 14 Jan 2013 07:34:38 -0800 (PST)
In-Reply-To: <20130114142005.GC12052@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 01/14/2013 11:20 AM, Theodore Ts'o wrote:

> why bother using autoconf and automake

For a very simple reason, fixing hand written makefiles is the number 1 
burden in distribution mainteniance.

Any autotools stuff provided is always better and causes less pain than 
ad-hoc build scripts.

This is why you see frecuent requests to use autotools, because hand 
crafted stuff breaks literally everyday, just ask any distribution 
packager if you dont believe me.



