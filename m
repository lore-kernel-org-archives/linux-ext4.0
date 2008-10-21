From: Daniel Phillips <phillips@phunq.net>
Subject: Re: [PATCH,RFC] ext3: Add support for non-native signed/unsigned htree hash algorithms
Date: Tue, 21 Oct 2008 14:50:59 -0700
Message-ID: <200810211450.59184.phillips@phunq.net>
References: <1224560624-9691-1-git-send-email-tytso@mit.edu> <1224560624-9691-2-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	akpm@linux-foundation.org, linux-kernel@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1756173AbYJUVvV@vger.kernel.org>
In-Reply-To: <1224560624-9691-2-git-send-email-tytso@mit.edu>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Monday 20 October 2008 20:43, Theodore Ts'o wrote:
> +static __u32 dx_hack_hash (const char *name, int len, int unsigned_flag)
> ...
> +		if (unsigned_flag)
> +			c = (int) *ucp++;
> +		else
> +			c = (int) *scp++;

This being a high performance hash function and all, why not something
like:

+static __u32 uchar_hack_hash (const char *name, int len)
+...

+static __u32 char_hack_hash (const char *name, int len)
+...

+static __u32 dx_hack_hash(const char *name, int len, int unsigned_flag)
+{
+	if (unsigned_flag)
+		return uchar_hack_hash(name, len);
+	return char_hack_hash(name, len);
+}
