From: Andreas Gruenbacher <agruenba@redhat.com>
Subject: e2fsprogs: Richacl support
Date: Fri, 16 Oct 2015 18:03:29 +0200
Message-ID: <CAHc6FU5s7-t3+jtKDusVFqc542Ag7pEOTUqp1LSxg8_uCPyF=A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-ext4 <linux-ext4@vger.kernel.org>,
	"Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-lb0-f169.google.com ([209.85.217.169]:34531 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932833AbbJPQDb (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 16 Oct 2015 12:03:31 -0400
Received: by lbbwb3 with SMTP id wb3so42316631lbb.1
        for <linux-ext4@vger.kernel.org>; Fri, 16 Oct 2015 09:03:29 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello,

could the richacl feature flag please be added to e2fsprogs so that we
won't end up with incompatible file systems?

  https://github.com/andreas-gruenbacher/e2fsprogs

Also, should this really be an incompatible feature flag? With a
read-only compatibility flag, mounting a richacl filesystem on a
kernel without richacl support would work but it's not safe --- it
could grant unwanted access to files. (The same applies to the xfs
support, etc.)

Thanks,
Andreas
