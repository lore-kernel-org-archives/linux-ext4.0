From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: [PATCH] ext4: fix ext4_flush_completed_IO wait semantics
Date: Wed, 03 Oct 2012 23:32:27 +0400
Message-ID: <87lifns65w.fsf@openvz.org>
References: <1349289807-18811-1-git-send-email-dmonakhov@openvz.org> <20121003185558.GB5160@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, jack@suse.cz
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-la0-f46.google.com ([209.85.215.46]:49450 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751132Ab2JCTca (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 3 Oct 2012 15:32:30 -0400
Received: by lagh6 with SMTP id h6so3173225lag.19
        for <linux-ext4@vger.kernel.org>; Wed, 03 Oct 2012 12:32:29 -0700 (PDT)
In-Reply-To: <20121003185558.GB5160@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, 3 Oct 2012 14:55:58 -0400, "Theodore Ts'o" <tytso@mit.edu> wrote:
> Are you planning on updating the 'ext4: completed_io locking cleanup
> V4' patch series, or is this an additional patch that should be tacked
> on to it?
This is addidional patch which should be placed on top of
'ext4: completed_io locking cleanup V4'
I'll try to convince Jan Kara that this is the best way to fix both bugs.
