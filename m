From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH resend] Update atime from future.
Date: Tue, 4 Jan 2011 12:13:37 -0700
Message-ID: <2321F6F6-1042-48E8-9F21-12C52E8FFFCC@dilger.ca>
References: <1294131418-3835-1-git-send-email-sickamd@gmail.com> <13585.1294165307@localhost>
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: yangsheng <sickamd@gmail.com>, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	swhiteho@redhat.com, sickadm@gmail.com
To: Valdis.Kletnieks@vt.edu
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <13585.1294165307@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 2011-01-04, at 11:21, Valdis.Kletnieks@vt.edu wrote:
> On Tue, 04 Jan 2011 16:56:58 +0800, yangsheng said:
>> If atime has been wrong set to future, then it cannot
>> be updated back to current time.
>> 
>> +#define RELATIME_MARGIN (24 * 60 * 60)
> 
> Nice patch overall.  Should this be a #define, or a CONFIG_ variable,
> or a tweakable /proc/sys/fs variable?  Or am I senile and we thrashed
> all this out once before when the relatime code landed?

I recall the consensus was that a /proc tunable was "too much" for the initial patch.  An atime update interval of 1 day is sufficient for most applications, since they run daily to do file access scanning.  The #define was added because I dislike having multiple hard-coded values in any code.

I haven't heard of any complaints about the relatime update frequency, except for this "atime in the future" problem, so until that happens we may as well leave it as-is.

Cheers, Andreas
