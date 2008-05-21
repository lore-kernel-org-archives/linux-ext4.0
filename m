From: "rae l" <crquan@gmail.com>
Subject: Theodore Ts'o: please consider dis-ambiguity
Date: Wed, 21 May 2008 11:23:11 +0800
Message-ID: <91b13c310805202023n8c47ebfqef3206a55ead551e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ti-out-0910.google.com ([209.85.142.185]:39885 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754294AbYEUDXO (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 20 May 2008 23:23:14 -0400
Received: by ti-out-0910.google.com with SMTP id b6so1288674tic.23
        for <linux-ext4@vger.kernel.org>; Tue, 20 May 2008 20:23:11 -0700 (PDT)
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore:
please consider delete that tag "origin" in the ext4.git repo:

http://git.kernel.org/?p=linux/kernel/git/tytso/ext4.git

as a common case, I cloned a local repo from torvalds/linux-2.6.git
and fetched from tytso/ext4.git,

and when I want to gen patches, I do "git format-patch origin",
hundreds of patches generated,
but in fact I only have several patches.

then I realized there are ambiguities about the name "origin",

$ git rev-parse origin
warning: refname 'origin' is ambiguous.
492c2e476eac010962850006c49df326919b284c
$ git rev-parse origin/master
d40ace0c7b4a329f7d869d0fbf27435543bb2acc
$ git rev-parse origin/HEAD
d40ace0c7b4a329f7d869d0fbf27435543bb2acc

-- 
Denis Cheng
Linux Application Developer

"One of my most productive days was throwing away 1000 lines of code."
 - Ken Thompson.
