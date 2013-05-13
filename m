From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: EXT4 regression caused 4eec7
Date: Mon, 13 May 2013 11:34:12 -0500
Message-ID: <51911604.2060805@redhat.com>
References: <6719519.5821368147110937.JavaMail.weblogic@epml17> <20130510192747.GA11707@thunk.org> <87y5bm53z3.fsf@openvz.org> <87txm96fkd.fsf@openvz.org> <87mws1eq6y.fsf@openvz.org> <20130511230559.GD26298@thunk.org> <87a9o01siw.fsf@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "Theodore Ts'o" <tytso@mit.edu>,
	EUNBONG SONG <eunb.song@samsung.com>, Jan Kara <jack@suse.cz>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	linux-xfs@vger.kernel.org, Dave Chinner <david@fromorbit.com>
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <87a9o01siw.fsf@openvz.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 5/12/13 4:01 AM, Dmitry Monakhov wrote:
> In fact '4eec70' are vexing because I have reviewed and tested this patch before
> it was marked as Review-by, but missed the bug. This is because xfstests
> was executed manually logs was full of warnings but tainted flag was not
> checked at the end. 

Can you elaborate on this?  What was logged, and is it something we could
try to pick up post-test in xfstests?

Thanks,
-Eric
