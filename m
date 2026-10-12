Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5D313A4F50;
	Mon, 12 Oct 2026 23:12:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791846723; cv=none; b=N4dgO+jsaZ9aGfcku6Vdr3OL3PYo1fT9RId7HPYXa8Hfwy4T8YCmhDU43HUZ+j+QzJAc8WVqUYCodxf1SP9Th6FVAYgQK6W8gnA8KhJ71ybBZuvuonf1Ds6uwfNQHgPh3OVGohFVRaLgGogOcXIj2Jps30Cvk/ev2nILtxnraFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791846723; c=relaxed/simple;
	bh=dEYLVVwN31rGY8Ihgme1LSkvpWcfA70OxDVxGpc1Q2Q=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=eWhNJOR606qALg3k2AYfIw+vakdXa2qKUPf5bSFn/AtNDbjJ3Qc3a8d8waEro+cyaXD4yn7e8ewdiW6BX5lqgBw1hOIJGGMi8Z9eFzAvKmt2+0sNAaXiksdV5I/oFcqGLu7SIAxLhAWxPXt8WfLtYZBv76NM4xv0m1JO/EpDd6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SUtFbuhR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SUtFbuhR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85B6C1F008A1;
	Mon, 12 Oct 2026 23:11:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791846722;
	bh=sYxVPNTghx5Je+xlIpNxnYqdjbFjSIOMojl5QUCm+O4=;
	h=From:Subject:Date:To:Cc;
	b=SUtFbuhRrgY3EzT2RpzpPWl4i7q9C1SoXxYQRzAeXjAPJT6n3qMww7SQlGNlnHGwc
	 T06xmK1SHOB9uvl/Q29uasa/i2GJVTw7s486WqtnoXMXCUIO4KuJFP+1AjBG7ZYTqW
	 0fVJGz43cBnzeKsPKQfAVYPOiFgaDj72nO5rWtWNQ8gvZ7uswKd04qSAfSJcao3kAr
	 KbJeu3rALQ1FL+vf5wdAxI0mTQ7Lzu0znilHqr2168/+u9eJeuFrz1uai37ZNO0pnm
	 g1DVZvFoolBBhe3FlfCMiLIFq1tfPRQQDGdo07XzQEIYbGXWJZ6mOCJ/h6wobBBZwh
	 UPVyl5K+hrdtQ==
From: Mark <broonie@kernel.org>
Subject: [PATCH 0/9] kunit: Add KUNIT_CASE_PARAM_UNIQUE() and
 KUNIT_CASE_PARAM_WITH_INIT_UNIQUE()
Date: Tue, 13 Oct 2026 00:10:10 +0100
Message-Id: <20261013-kunit-param-names-v1-0-4b22ec5b85b9@kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIANNozWoC/yXMPQ6DMAxA4asgz1hKws/Qq1QMwbjUrQgoJggJc
 XdSOn7DewcoR2GFR3FA5E1U5pBhywLo7cPIKEM2OONaa6zDbwqy4uKjnzD4iRWHlnpbN4YqYsj
 dEvkl+/18dn9r6j9M628E53kB/9U0h3UAAAA=
X-Change-ID: 20261012-kunit-param-names-d6cb1450c3ce
To: Simon Trimmer <simont@opensource.cirrus.com>, 
 Charles Keepax <ckeepax@opensource.cirrus.com>, 
 Richard Fitzgerald <rf@opensource.cirrus.com>, 
 Brendan Higgins <brendan.higgins@linux.dev>, David Gow <david@davidgow.net>, 
 Rae Moar <raemoar63@gmail.com>, Jonathan Corbet <corbet@lwn.net>, 
 Shuah Khan <skhan@linuxfoundation.org>, 
 Randy Dunlap <rdunlap@infradead.org>, Theodore Ts'o <tytso@mit.edu>, 
 Andreas Dilger <adilger.kernel@dilger.ca>, 
 Baokun Li <libaokun@linux.alibaba.com>, Jan Kara <jack@suse.cz>, 
 Ojaswin Mujoo <ojaswin@linux.ibm.com>, 
 "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, 
 Zhang Yi <yi.zhang@huawei.com>, David Rhodes <david.rhodes@cirrus.com>, 
 Liam Girdwood <lgirdwood@gmail.com>, Jaroslav Kysela <perex@perex.cz>, 
 Takashi Iwai <tiwai@suse.com>
Cc: patches@opensource.cirrus.com, linux-kernel@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, kunit-dev@googlegroups.com, 
 linux-doc@vger.kernel.org, linux-ext4@vger.kernel.org, 
 linux-sound@vger.kernel.org, Mark Brown <broonie@kernel.org>
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=3187; i=broonie@kernel.org;
 h=from:subject:message-id; bh=dEYLVVwN31rGY8Ihgme1LSkvpWcfA70OxDVxGpc1Q2Q=;
 b=owGbwMvMwCWm/754w+YLFp2Mp9WSGLLOZlrNvOXVHHe7JtPY7nKusE315pZzj1dxqv3O7+f/u
 fPz1ltPO0pZGMS4GGTFFFnisrhf1pe8XsN3cGEbzBxWJpAhDFycAjARh88M/113PSvZL/WlwmTn
 NLfmj6d3WSZ3XJj1rJAhwpiLJ/POjUiG/8muTN/i16ovPCpi7BzloHd1a3he3fJbDG+EjnZEBvD
 84AIA
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB

KUNIT_CASE_PARAM() and KUNIT_CASE_PARAM_WITH_INIT() name the test case
after the test function. Several suites reuse one test function with
more than one parameter generator or param_init() function, listing it
once per set of parameters, which leads to multiple tests being created
with the same name. Same-named cases cannot be told apart in the results
and cannot be selected individually with kunit.filter_glob=, so kunit.py
--run_isolated=test boots a kernel for every entry and each kernel runs
all of the same-named cases.

We could fix this by having the KUNIT_CASE_PARAM() macros always include
the parameter name but this would not only rename all existing users but
also result in some awkwardly named tests. Instead introduce some new
macros for use in cases where we need to disambiguate.

Add KUNIT_CASE_PARAM_UNIQUE() and KUNIT_CASE_PARAM_WITH_INIT_UNIQUE()
which behave identically to the existing macros but include the name of
the parameter generator or the param_init() function in the name of
the case, giving names such as sha1_test-sha1_gen_params. The
param_init() function is used for the WITH_INIT variant since currently
all the tests which register parameter arrays from param_init() all
share the generic kunit_array_gen_params() generator.

The series also includes a fix for what looks like a cut'n'paste
issue in the cs_dsp code that overlaps with the main set of changes.
Most of the affected tests are in ASoC, though there are some ext4 tests
too.

Signed-off-by: Mark Brown <broonie@kernel.org>
---
Mark (8):
      firmware: cs_dsp: Run the wmfw payload error tests with invalid block types
      kunit: Add KUNIT_CASE_PARAM_UNIQUE() and KUNIT_CASE_PARAM_WITH_INIT_UNIQUE()
      ext4: Give the extents KUnit cases distinct names
      firmware: cs_dsp: Give the control read/write KUnit cases distinct names
      firmware: cs_dsp: Give the control cache KUnit cases distinct names
      firmware: cs_dsp: Give the wmfw block error KUnit cases distinct names
      firmware: cs_dsp: Give the bin file KUnit cases distinct names
      ASoC: wm_adsp: Give the firmware search order KUnit cases distinct names

Mark Brown (1):
      ASoC: cs35l56: Give the speaker ID pad config KUnit cases distinct names

 Documentation/dev-tools/kunit/usage.rst            |   9 +
 drivers/firmware/cirrus/test/cs_dsp_test_bin.c     | 222 ++++++++++-----------
 .../cirrus/test/cs_dsp_test_control_cache.c        | 143 ++++++-------
 .../firmware/cirrus/test/cs_dsp_test_control_rw.c  |  50 ++---
 .../firmware/cirrus/test/cs_dsp_test_wmfw_error.c  |  72 ++++---
 fs/ext4/extents-test.c                             |  12 +-
 include/kunit/test.h                               |  41 ++++
 sound/soc/codecs/cs35l56-shared-test.c             |   8 +-
 sound/soc/codecs/wm_adsp_fw_find_test.c            |  24 +--
 9 files changed, 329 insertions(+), 252 deletions(-)
---
base-commit: 24a19b953e2a3d0ea5a8c4951a0ab8f32720c907
base-tree: git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
change-id: 20261012-kunit-param-names-d6cb1450c3ce

Best regards,
--  
Mark Brown <broonie@kernel.org>

