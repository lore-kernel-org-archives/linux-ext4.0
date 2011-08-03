From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
Subject: Re: [PATCH] jbd/jbd2: add pointer type conversion on void *arg from
 void * to journal_t * explicitly in kjournald/kjournald2
Date: Wed, 3 Aug 2011 10:52:47 +0800
Message-ID: <CAM_iQpXJSDvHXtGFET7SgQTXUpk-v+hD24RzSR-sanf=4oY1xA@mail.gmail.com>
References: <4E38AB50.9040804@gmail.com>
	<4E38AC92.4090501@cn.fujitsu.com>
	<4E38AFC2.3070608@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Li Zefan <lizf@cn.fujitsu.com>, "Theodore Ts'o" <tytso@mit.edu>,
	Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Wang Sheng-Hui <shhuiw@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:61543 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753385Ab1HCCws (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 2 Aug 2011 22:52:48 -0400
In-Reply-To: <4E38AFC2.3070608@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Aug 3, 2011 at 10:17 AM, Wang Sheng-Hui <shhuiw@gmail.com> wrote:
>
> I remember any * can be assigned directly to void * in ANSI C, but
> void * should be converted to specific point * type. Right?
>

C99 6.3.2.3

A pointer to void may be converted to or from a pointer to any
incomplete or object
type. A pointer to any incomplete or object type may be converted to a
pointer to void
and back again; the result shall compare equal to the original pointer.
