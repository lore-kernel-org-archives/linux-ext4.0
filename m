From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v2 0/8] Introduce strreplace
Date: Tue, 9 Jun 2015 14:02:43 -0700
Message-ID: <20150609140243.e2ef7e9f22416c82a334f031@linux-foundation.org>
References: <1433806017-10823-1-git-send-email-linux@rasmusvillemoes.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Neil Brown <neilb@suse.de>, "Theodore Ts'o" <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ingo Molnar <mingo@redhat.com>, Joe Perches <joe@perches.com>,
	Al Viro <viro@ZenIV.linux.org.uk>,
	linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
	linux-ext4@vger.kernel.org
To: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1433806017-10823-1-git-send-email-linux@rasmusvillemoes.dk>
Sender: linux-raid-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue,  9 Jun 2015 01:26:48 +0200 Rasmus Villemoes <linux@rasmusvillemoes.dk> wrote:

> Doing single-character substitution on an entire string is open-coded
> in a few places, sometimes in a rather suboptimal way. This introduces
> a trivial helper, strreplace, for this task along with a few example
> conversions.
> 
> Andrew, can I get you to take 1/8 through the mm tree? I'm not sure
> what the easiest path is for the remaining patches.

With this sort of thing I grab everything them feed the dependent
patches to maintainers after the base patch is upstream.

Or I merge the dependent patches myself if they were acked.

Or if the dependent patches are simple I'll just merge them anyway,
shrug.  I'd say these fall into that category.

