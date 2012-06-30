From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 1/2] Add a new helper for sleepable BTM acquirements
 which is used by tty_write_message()
Date: Sat, 30 Jun 2012 13:35:49 +0100
Message-ID: <20120630133549.2431968e@pyramind.ukuu.org.uk>
References: <4FEEC96E.9070502@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-serial@vger.kernel.org,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	gregkh@linuxfoundation.org, Jan Kara <jack@suse.cz>,
	"Ted Ts'o" <tytso@mit.edu>
To: jeff.liu@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:45192 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754613Ab2F3Mb5 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 30 Jun 2012 08:31:57 -0400
In-Reply-To: <4FEEC96E.9070502@oracle.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, 30 Jun 2012 17:39:58 +0800
Jeff Liu <jeff.liu@oracle.com> wrote:

> This helper only used by tty_write_message(), it will sleep until BTM lock acquired.

This makes no sense at all. mutexes already sleep. Your code is also
wrong for real time processes.

So NAK.
