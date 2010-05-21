From: tytso@mit.edu
Subject: Re: [PATCH] ext4: Add data string to mount message, and new
 remount message
Date: Thu, 20 May 2010 20:39:27 -0400
Message-ID: <20100521003927.GB7791@thunk.org>
References: <AANLkTinOCWC_gnQlfwjH7wYgoJkZY3mOEhOV8r3GfaC6@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Curt Wohlgemuth <curtw@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:35695 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752251Ab0EUAja (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 20 May 2010 20:39:30 -0400
Content-Disposition: inline
In-Reply-To: <AANLkTinOCWC_gnQlfwjH7wYgoJkZY3mOEhOV8r3GfaC6@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, May 04, 2010 at 08:57:02AM -0700, Curt Wohlgemuth wrote:
> This adds a "re-mounted" message to ext4_remount(), and both it and the
> mount message in ext4_fill_super() now have the original data string.
> 
>Signed-off-by: Curt Wohlgemuth <curtw@google.com>

Added to the ext4 patch queue

					- Ted
