From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] jbd2: prefix printks with JBD2: not JBD:
Date: Mon, 12 May 2014 09:28:52 -0500
Message-ID: <5370DAA4.7040401@redhat.com>
References: <536A652C.7080509@redhat.com> <20140512001726.GF5480@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:17085 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758288AbaELO2x (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 12 May 2014 10:28:53 -0400
In-Reply-To: <20140512001726.GF5480@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 5/11/14, 7:17 PM, Theodore Ts'o wrote:
> What kernel version is this against?  This has been fixed since 3.13:

Oh, I'm sorry.  It was against "upstream" but on a box where I had
inexplicably not done a git pull for a long while, an just assumed
I was up to date.  :(  Sorry for the noise.

-Eric
