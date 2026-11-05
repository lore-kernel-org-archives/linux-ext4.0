Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793894513;
	b=16ab9pmczjvQ4MqZeAF4SQ4MSFwAEAuNpsC0bpOChfCAglywy8yufF+W45t50RpF1j/a
	 +A73pjlH0mlpGHBhIF2tTo3UNnVXhwr9OGV/gnJ7VbYvOushLtcbxmLGhP5atkn5Hjbt5
	 nXYggtJW0irZJ38W+fKdNBmv7qdmEjtxluyeHQsTZ+pP0FSyKwM8tXbHMfRgHuUjQAj+y
	 hPs5tqoiRRV3SRPtBFVd0VOvRLnQc2erA40NVLgucTzlZ9SIg0G+KQIkh4bJVfJaS3SA6
	 MIawVlvDiAF5KFF/omdyU39hkwXToBp939CMRPmfXpHqa1T5Q5yFJ12TsxgLf54wjnA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793894513;
	h=Received:DKIM-Signature:From:Subject:Date:Message-Id:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:X-B4-Tracking:X-Change-ID:To:
	 Cc:X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=4VelVPMVxE7skvZV+t/dDAKOEE6lwzzBgv28kRT0Ubk=;
	b=hRnJVr3boxWjnqxTexiU01Swesb02o+XVjm9hF/ToX5UpZG44DXnllhrJv04T+rFEQwB
	 Ts/Lu40Lbsh/aWY/FPk9eoTCErSxbV1Ai+GthuXI6tE8pgBmcgytNvk8d+MXzJ8UoaNzH
	 AcR+pYQQhKmsB2wU5+zK1hvD68gph5siiB2k71V2b38Y4sFr7jWs+tf5pHCL52kFMIL6K
	 SA5OnAuvHLcaQ1NfO3QmKNkZypjPMIMJSrcZPp+ki0C7TIGMsXwrM19VcO9AAJ/DUWDVJ
	 u4PO5YStTrknw1BkPmgw+HjUBL64rE1Qxj/g2knQdVo9lUobI8EbcvXHk8oTe4EVKow==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DQOm1YJH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60DB6606B45C;
	Thu,  5 Nov 2026 16:01:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DQOm1YJH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A1C01F000C1;
	Thu,  5 Nov 2026 16:01:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793894513;
	bh=4VelVPMVxE7skvZV+t/dDAKOEE6lwzzBgv28kRT0Ubk=;
	h=From:Subject:Date:To:Cc;
	b=DQOm1YJHfPm0v/dLeX+XAQitvcUgNmsRePnWyLGO6bQ1h7mTPBBwMcAFJ/zylkp6x
	 JRSvS6x2PxHBQsNb/u8MQKHzOvOm8IIek6H13FQEo5WnomxQtacBL6ZdOTagLV0Us/
	 8MEjtRHH8GOha7MIaWgrfOnrRSZEDiFYtGzXlfovCOTmzacIhMIFTKXndgH0SaTFOd
	 l0Bc059PPlKXuS0nuonAXvjDjQjQPb8+m+axQDqp25tJl/70i8yHj7ucErATfhcqvI
	 1XnJskLP2DXG6TQtrW6C81etXnTtmeAvYcpVQl/e/P8igcYBQaSam4mqrQuYm1C0dr
	 /ZBkyLilhWMLw==
From: Mark Brown <broonie@kernel.org>
Subject: [PATCH v2 0/9] kunit: Add KUNIT_CASE_PARAM_UNIQUE() and
 KUNIT_CASE_PARAM_WITH_INIT_UNIQUE()
Date: Thu, 05 Nov 2026 16:00:27 +0000
Message-Id: <20261105-kunit-param-names-v2-0-765b3d5275d2@kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAB2o7GoC/22Nyw6CMBBFf4XM2jFteURd+R+GRVtGqEhLpkA0h
 H8XMO5cnuTcc2eIxI4iXJIZmCYXXfArqEMCttG+JnTVyqCEKqSQCtvRuwF7zbpDrzuKWBXWyCw
 XNrUE665nurvX3ryVX46jeZAdttBmNC4Ogd/76SQ379dP//QniQIzoxTZ3Jxyc762xJ6ex8A1l
 MuyfADbwZgBxQAAAA==
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=3315; i=broonie@kernel.org;
 h=from:subject:message-id; bh=wulIPaLUroDjaKiDD9mihUIfKXwA5W+VsQnKLwr9e6M=;
 b=owGbwMvMwCWm/754w+YLFp2Mp9WSGLLerEjtOnFs5eQDOeGt5QlfmR8tmV/9tUD6/J6wz7rvb
 6+qDPIt7ChlYRDjYpAVU2SJy+J+WV/yeg3fwYVtMHNYmUCGMHBxCsBE1P4wMtzhSdCSeT1fZMaz
 5oO+Zc+69+ySqBI22Wh4nrFCPJujYQIjww7WzdYBaoKuviYqwh/rLBOm2PKnuchINEQcUxYQXMH
 MBwA=
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
Changes in v2:
- Rebase onto v7.4-rc1.
- Link to v1: https://patch.msgid.link/20261013-kunit-param-names-v1-0-4b22ec5b85b9@kernel.org

---
Mark Brown (9):
      firmware: cs_dsp: Run the wmfw payload error tests with invalid block types
      kunit: Add KUNIT_CASE_PARAM_UNIQUE() and KUNIT_CASE_PARAM_WITH_INIT_UNIQUE()
      ext4: Give the extents KUnit cases distinct names
      firmware: cs_dsp: Give the control read/write KUnit cases distinct names
      firmware: cs_dsp: Give the control cache KUnit cases distinct names
      firmware: cs_dsp: Give the wmfw block error KUnit cases distinct names
      firmware: cs_dsp: Give the bin file KUnit cases distinct names
      ASoC: cs35l56: Give the speaker ID pad config KUnit cases distinct names
      ASoC: wm_adsp: Give the firmware search order KUnit cases distinct names

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
base-commit: 6628e7d4c6b25c8d18f1345e3a20d21829aae7e4
base-tree: git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm master
change-id: 20261012-kunit-param-names-d6cb1450c3ce

Best regards,
--  
Mark Brown <broonie@kernel.org>

