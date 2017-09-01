From: Gabriel Krisman Bertazi <krisman@collabora.co.uk>
Subject: [RFC] Ext4 case insensitive proposal
Date: Fri, 01 Sep 2017 02:57:44 -0300
Message-ID: <871snrvu3r.fsf@dilma.collabora.co.uk>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, adilger.kernel@dilger.ca
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:34451 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750910AbdIAF5v (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 1 Sep 2017 01:57:51 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


As a follow-up on the discussions held in this list after Ted's proposal
on case-insensitive support for ext4 last year, I've implemented a my
version of it to learn my way through the ext4 code, and to get started
on the task.  As my goal would be a slightly more complex approach, with
at least UTF-8 support for lookups, I'd like to hear from you about my
current implementation and the following proposal, as well as if there
is anyone currently working on anything like this, so we could
coordinate efforts.

Regarding the Unicode proposal (shivers), I am aware of Ben and
Olaf's proposal from 2014, and I plan to work on top of that to get it
updated and upstream.

Please, let me know your thoughts.

* Current Implementation

Simple learning experience to get the wheel spinning, based on Ted Ts'o
initial proposal back in 2016 [1].  It supports ASCII-case folding only
and doesn't rely on on-disk modifications.

Available at:
 https://git.collabora.com/cgit/user/krisman/linux.git/log/?h=ext4-insensitive

- Implemented as a mount option, called ignorecase, which enables
  insensitive lookups for the entire filesystem.  A look-up will first
  attempt the htree search for an exact-case match and if that fails,
  fallback to a performing the expensive linear search.

- ASCII case-folding only.

- No on-disk format changes.

- If two files differ only by case, an exact-case lookup will return the
  expected file.  A non-exact-case lookup result will be unpredictable
  as to which file is returned (depends on the order on-disk).

* Proposal

- Make insensitive lookups enabled on a per-directory basis via an
  attribute.

- Support UTF-8 encoding in-kernel for case folding.

- sb will store the information required for unicode versioning and
  encoding.

- Empty directories are optimized with an insensitive hash for htree
  lookups.

- Fallback to linear searches on directories not optimized.

[1] https://www.spinics.net/lists/linux-ext4/msg54279.html

-- 
Gabriel Krisman Bertazi
