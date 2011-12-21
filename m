From: Junio C Hamano <gitster@pobox.com>
Subject: Re: [GIT PULL] ext4 bugfixes for 3.2-rc5
Date: Tue, 20 Dec 2011 21:37:50 -0800
Message-ID: <7v8vm6iixd.fsf@alter.siamese.dyndns.org>
References: <E1RauNd-0008W1-02@tytso-glaptop.cam.corp.google.com>
 <CA+55aFw6n=WaDWRn7NqtBei1x0-w1PkH5x6r3iQSSPZvxYvDhQ@mail.gmail.com>
 <20111215190846.GA2709@thunk.org> <7vd3biijdc.fsf@alter.siamese.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <7vd3biijdc.fsf@alter.siamese.dyndns.org> (Junio C. Hamano's
 message of "Tue, 20 Dec 2011 21:28:15 -0800")
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Junio C Hamano <gitster@pobox.com> writes:

> Ted Ts'o <tytso@mit.edu> writes:
> ...
>> And this isn't in 1.7.8 yet, right?  I'd have to build version of git
>> based on the next branch to play with this new signatury goodness?
>
> The 'master' branch as of this week has the topic merged.

Also please notice that the original "pull request" said:

    Hi Linus,

    There is a signed tag tytso-for-linus-20111214 covering these patches,...
    Please pull,

                                                    - Ted

    The following changes since commit dc47ce90c3a822cd7c9e9339fe4d5f61dcb26b50:

      Linux 3.2-rc5 (2011-12-09 15:09:32 -0800)

    are available in the git repository at:
      git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git dev

    Andrea Arcangeli (1):
          ext4: avoid hangs in ext4_da_should_update_i_disksize()
    ... shortlog output ...

that mentions where the work forked, but does _not_ mention what tip
commit of "dev" branch to expect. Updated "git request-pull" command will
have that information, and also gives the tag name you already pushed out
to your publishing repository instead of the branch name "dev" when
producing the "... available in the git repository at:" information.
