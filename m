From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH v3 0/2] ext4: increase mbcache scalability
Date: Tue, 10 Sep 2013 22:13:16 -0500
Message-ID: <522FDFCC.1070007@redhat.com>
References: <1374108934-50550-1-git-send-email-tmac@hp.com> <1378312756-68597-1-git-send-email-tmac@hp.com> <20130905023522.GA21268@thunk.org> <52285395.1070508@hp.com> <0787C579-7E2C-4864-B8F4-98816E1E50A2@dilger.ca> <5229C939.8030108@hp.com> <62D71A85-C7EE-4F5F-B481-5329F0282044@dilger.ca> <20130910210250.GH29237@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: "Theodore Ts'o" <tytso@mit.edu>,
	Andreas Dilger <adilger@dilger.ca>,
	Thavatchai Makphaibulchoke <thavatchai.makpahibulchoke@hp.com>,
	T Makphaibulchoke <tmac@hp.com>,
	Al Viro <viro@zeniv.linux.org.uk>,
	"linux-ext4@vger.kernel.org List" <linux-ext4@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	"linux-fsdevel@vger.kernel.org Devel" <linux-fsdevel@vger.kernel.org>,
	aswin@hp.com, Linus Torvalds <torvalds@linux-foundation.org>,
	aswin_proj@lists.hp.com
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20130910210250.GH29237@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 9/10/13 4:02 PM, Theodore Ts'o wrote:
> On Tue, Sep 10, 2013 at 02:47:33PM -0600, Andreas Dilger wrote:
>> I agree that SELinux is enabled on enterprise distributions by default,
>> but I'm also interested to know how much overhead this imposes.  I would
>> expect that writing large external xattrs for each file would have quite
>> a significant performance overhead that should not be ignored.  Reducing
>> the mbcache overhead is good, but eliminating it entirely is better.
> 
> I was under the impression that using a 256 byte inode (which gives a
> bit over 100 bytes worth of xattr space) was plenty for SELinux.  If
> it turns out that SELinux's use of xattrs have gotten especially
> piggy, then we may need to revisit the recommended inode size for
> those systems who insist on using SELinux...  even if we eliminate the
> overhead associated with mbcache, the fact that files are requiring a
> separate xattr is going to seriously degrade performance.

On my RHEL6 system,

# find / -xdev -exec getfattr --only-values -m security.* {} 2>/dev/null \; | wc -c
11082179

bytes of names for:

# df -i /
Filesystem            Inodes   IUsed   IFree IUse% Mounted on
/dev/mapper/vg_bp05-lv_root
                     3276800  280785 2996015    9% /

280785 inodes used,

so:
11082179/280785 = ~39.5 bytes per value on average, plus:

# echo -n "security.selinux" | wc -c
16

16 bytes for the name is only about 55-56 bytes per selinux attr on average.

So nope, not "especially piggy" on average.

Another way to do it is this; list all possible file contexts, and make
a histogram of sizes:

# for CONTEXT in `semanage fcontext -l | awk '{print $NF}' `; do echo -n $CONTEXT | wc -c; done | sort -n | uniq -c
      1 7
     33 8
    356 26
     14 27
     14 28
     37 29
     75 30
    237 31
    295 32
    425 33
    324 34
    445 35
    548 36
    229 37
    193 38
    181 39
    259 40
     81 41
    108 42
     96 43
     55 44
     55 45
     16 46
     41 47
     23 48
     28 49
     36 50
     10 51
     10 52
      5 54
      2 57

so a 57 byte value is max, but there aren't many of the larger values.

Above doesn't tell us the prevalence of various contexts on the actual system,
but they are all under 100 bytes in any case.

-Eric

> 	       	  	   	     - Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
