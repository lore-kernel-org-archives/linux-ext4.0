From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH 42/42] ext4: Rename ext4dev to ext4
Date: Sat, 11 Oct 2008 20:06:55 -0500
Message-ID: <48F14DAF.8060306@redhat.com>
References: <1223525160-9887-36-git-send-email-tytso@mit.edu> <1223525160-9887-37-git-send-email-tytso@mit.edu> <1223525160-9887-38-git-send-email-tytso@mit.edu> <1223525160-9887-39-git-send-email-tytso@mit.edu> <1223525160-9887-40-git-send-email-tytso@mit.edu> <1223525160-9887-41-git-send-email-tytso@mit.edu> <1223525160-9887-42-git-send-email-tytso@mit.edu> <1223525160-9887-43-git-send-email-tytso@mit.edu> <48F122FC.6040107@goop.org> <48F12427.5090801@redhat.com> <20081011225826.GD12662@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: Theodore Tso <tytso@mit.edu>, Eric Sandeen <sandeen@redhat.com>,
	Jeremy Fitzhardinge <jeremy@goop.org>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:37275 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751261AbYJLBH0 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 11 Oct 2008 21:07:26 -0400
In-Reply-To: <20081011225826.GD12662@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Tso wrote:

> The only other problem may arise on distro's that depend on vol_id for
> mount/fsck, 

And hal (also used volume_id)...

And quota. (has "ext4dev" as a type but no ext4 atm)

-Eric
