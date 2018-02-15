From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] e2fsck: properly account cluster size
Date: Thu, 15 Feb 2018 13:41:40 -0500
Message-ID: <20180215184140.GA583@thunk.org>
References: <20180212120040.25441-1-artem.blagodarenko@gmail.com>
 <DC07AF86-4B27-4F94-AC08-096CDA3C8D67@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: linux-ext4@vger.kernel.org, Andrew Perepechko <anserper@ya.ru>
To: =?utf-8?B?0JHQu9Cw0LPQvtC00LDRgNC10L3QutC+INCQ0YDRgtGR0Lw=?=
        <artem.blagodarenko@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:48460 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1162720AbeBOSlm (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 15 Feb 2018 13:41:42 -0500
Content-Disposition: inline
In-Reply-To: <DC07AF86-4B27-4F94-AC08-096CDA3C8D67@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Feb 15, 2018 at 05:45:34PM +0300, Благодаренко Артём wrote:
> Sorry, this patch is duplicate of
> [PATCH] e2fsck: fix quota accounting to use cluster units
> from Eric W at 5 April.

... and which is e2fsprogs 1.43.5 and newer....

    	      	 	   	      - Ted
