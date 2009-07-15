From: Scott James Remnant <scott@ubuntu.com>
Subject: [PATCH] debian/control: fix incorrect use of apostrophe's
Date: Wed, 15 Jul 2009 15:43:21 +0100
Message-ID: <E1MR5ia-0003eM-EU@zelda.netsplit.com>
Cc: Theodore Tso <tytso@mit.edu>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from zelda.netsplit.com ([87.194.19.211]:49034 "EHLO
	zelda.netsplit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754531AbZGOOpM (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 15 Jul 2009 10:45:12 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Signed-off-by: Scott James Remnant <scott@ubuntu.com>
---
 debian/control |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/debian/control b/debian/control
index dc8df21..f930ddd 100644
--- a/debian/control
+++ b/debian/control
@@ -79,7 +79,7 @@ Replaces: e2fsprogs (<< 1.34-1)
 Architecture: any
 Description: Universally Unique ID library
  The libuuid library generates and parses 128-bit universally unique
- id's (UUID's).  A UUID is an identifier that is unique across both
+ ids (UUIDs).  A UUID is an identifier that is unique across both
  space and time, with respect to the space of all UUIDs.  A UUID can
  be used for multiple purposes, from tagging objects with an extremely
  short lifetime, to reliably identifying very persistent objects
@@ -95,7 +95,7 @@ Replaces: e2fsprogs (<= 1.40.3-1ubuntu1)
 Architecture: any
 Description: runtime components for the Universally Unique ID library
  The libuuid library generates and parses 128-bit universally unique
- id's (UUID's).  A UUID is an identifier that is unique across both
+ ids (UUIDs).  A UUID is an identifier that is unique across both
  space and time, with respect to the space of all UUIDs.  A UUID can
  be used for multiple purposes, from tagging objects with an extremely
  short lifetime, to reliably identifying very persistent objects
@@ -118,7 +118,7 @@ Priority: optional
 Depends: ${shlibs:Depends}
 Architecture: any
 Description: stripped down universally unique id library, for debian-installer
- libuuid generates and parses 128-bit universally unique id's (UUID's).
+ libuuid generates and parses 128-bit universally unique ids (UUIDs).
  See RFC 4122 for more information.
  .
  This is a minimal package for debian-installer.
@@ -130,7 +130,7 @@ Depends: libc6-dev | libc-dev, libuuid1 (= ${mainBinary})
 Replaces: e2fslibs-dev (<< 1.15)
 Architecture: any
 Description: universally unique id library - headers and static libraries
- libuuid generates and parses 128-bit universally unique id's (UUID's).
+ libuuid generates and parses 128-bit universally unique ids (UUIDs).
  See RFC 4122 for more information.
  .
  This package contains the development environment for the uuid library.
-- 
1.6.0.5

