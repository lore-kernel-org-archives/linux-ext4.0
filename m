From: Junio C Hamano <gitster@pobox.com>
Subject: Re: -tip: origin tree build failure
Date: Thu, 28 Oct 2010 14:39:13 -0700
Message-ID: <7veiba9ev2.fsf@alter.siamese.dyndns.org>
References: <E1PBKT9-0004Uk-Sm@tytso-glaptop> <20101028075631.GA7690@elte.hu>
 <AANLkTi=8SbOZizWpxLg=Bgp7atdgr8MsR6tnRDYr1+eW@mail.gmail.com>
 <20101028163854.GA15450@elte.hu>
 <AANLkTin62vAwJxcsrFk6Yn7Q6tzr-D=EmKKwPazuAJ11@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ingo Molnar <mingo@elte.hu>, "Theodore Ts'o" <tytso@mit.edu>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from a-pb-sasl-quonix.pobox.com ([208.72.237.25]:52184 "EHLO
	sasl.smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933157Ab0J1Vj3 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 28 Oct 2010 17:39:29 -0400
In-Reply-To: <AANLkTin62vAwJxcsrFk6Yn7Q6tzr-D=EmKKwPazuAJ11@mail.gmail.com>
 (Linus Torvalds's message of "Thu\, 28 Oct 2010 10\:00\:26 -0700")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Linus Torvalds <torvalds@linux-foundation.org> writes:

> Yes. Except for the kernel the default git commit abbreviation is
> borderline too short. Seven hex-chars can easily alias with a few more
> pulls from me: git will not give aliases at the time it gives a
> shorthand, but a month or two later the abbreviated commit may no
> longer be unique.
>
> So I suggest using --abbrev=12 or similar.

Would a new configuration to specify how many more letters to ensure the
uniqueness at the time of generation make sense?

By the way, I noticed that you started sending patches as attachments
lately.  What made you change your mind?

 Documentation/config.txt |    9 +++++++++
 cache.h                  |    1 +
 config.c                 |    7 +++++++
 environment.c            |    1 +
 sha1_name.c              |    4 +++-
 5 files changed, 21 insertions(+), 1 deletions(-)

diff --git a/Documentation/config.txt b/Documentation/config.txt
index 538ebb5..6994338 100644
--- a/Documentation/config.txt
+++ b/Documentation/config.txt
@@ -374,6 +374,15 @@ core.warnAmbiguousRefs::
 	If true, git will warn you if the ref name you passed it is ambiguous
 	and might match multiple refs in the .git/refs/ tree. True by default.
 
+core.abbrevguard::
+	Even though git makes sure that it uses enough hexdigits to show
+	an abbreviated object name unambiguously, as more objects are
+	added to the repository over time, a short name that used to be
+	unique will stop being unique.  Git uses this many extra hexdigits
+	that are more than necessary to make the object name currently
+	unique, in the hope that its output will stay unique a bit longer.
+	Defaults to 0.
+
 core.compression::
 	An integer -1..9, indicating a default compression level.
 	-1 is the zlib default. 0 means no compression,
diff --git a/cache.h b/cache.h
index 33decd9..931fb59 100644
--- a/cache.h
+++ b/cache.h
@@ -545,6 +545,7 @@ extern int assume_unchanged;
 extern int prefer_symlink_refs;
 extern int log_all_ref_updates;
 extern int warn_ambiguous_refs;
+extern int unique_abbrev_extra_length;
 extern int shared_repository;
 extern const char *apply_default_whitespace;
 extern const char *apply_default_ignorewhitespace;
diff --git a/config.c b/config.c
index 4b0a820..1aa72c2 100644
--- a/config.c
+++ b/config.c
@@ -489,6 +489,13 @@ static int git_default_core_config(const char *var, const char *value)
 		return 0;
 	}
 
+	if (!strcmp(var, "core.abbrevguard")) {
+		unique_abbrev_extra_length = git_config_int(var, value);
+		if (unique_abbrev_extra_length < 0)
+			unique_abbrev_extra_length = 0;
+		return 0;
+	}
+
 	if (!strcmp(var, "core.bare")) {
 		is_bare_repository_cfg = git_config_bool(var, value);
 		return 0;
diff --git a/environment.c b/environment.c
index de5581f..92e16b1 100644
--- a/environment.c
+++ b/environment.c
@@ -21,6 +21,7 @@ int prefer_symlink_refs;
 int is_bare_repository_cfg = -1; /* unspecified */
 int log_all_ref_updates = -1; /* unspecified */
 int warn_ambiguous_refs = 1;
+int unique_abbrev_extra_length;
 int repository_format_version;
 const char *git_commit_encoding;
 const char *git_log_output_encoding;
diff --git a/sha1_name.c b/sha1_name.c
index 484081d..4a226ad 100644
--- a/sha1_name.c
+++ b/sha1_name.c
@@ -206,7 +206,9 @@ const char *find_unique_abbrev(const unsigned char *sha1, int len)
 		if (exists
 		    ? !status
 		    : status == SHORT_NAME_NOT_FOUND) {
-			hex[len] = 0;
+			int cut_at = len + unique_abbrev_extra_length;
+			cut_at = (cut_at < 40) ? cut_at : 40;
+			hex[cut_at] = 0;
 			return hex;
 		}
 		len++;
