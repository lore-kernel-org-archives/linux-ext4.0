From: "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH 03/23] vfs: rich ACL in-memory representation and
	manipulation
Date: Mon, 01 Feb 2010 23:32:59 +0530
Message-ID: <87y6jczve4.fsf@linux.vnet.ibm.com>
References: <1265002505-8387-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
	<1265002505-8387-4-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
	<20100201072852.GA17309@cynthia.pants.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: sandeen@redhat.com, adilger@sun.com, tytso@mit.edu, jlayton@redhat.com,
	bfields@citi.umich.edu, nfsv4@linux-nfs.org,
	samba@lists.samba.org, linux-fsdevel@vger.kernel.org,
	sfrench@us.ibm.com, ffilz@us.ibm.com, linux-ext4@vger.kernel.org,
	agruen@suse.de
To: Brad Boyer <flar@allandria.com>
Return-path: <nfsv4-bounces@linux-nfs.org>
In-Reply-To: <20100201072852.GA17309@cynthia.pants.nu>
List-Unsubscribe: <http://linux-nfs.org/cgi-bin/mailman/options/nfsv4>,
	<mailto:nfsv4-request@linux-nfs.org?subject=unsubscribe>
List-Archive: <http://linux-nfs.org/pipermail/nfsv4>
List-Post: <mailto:nfsv4@linux-nfs.org>
List-Help: <mailto:nfsv4-request@linux-nfs.org?subject=help>
List-Subscribe: <http://linux-nfs.org/cgi-bin/mailman/listinfo/nfsv4>,
	<mailto:nfsv4-request@linux-nfs.org?subject=subscribe>
Sender: nfsv4-bounces@linux-nfs.org
Errors-To: nfsv4-bounces@linux-nfs.org
List-Id: linux-ext4.vger.kernel.org

On Sun, 31 Jan 2010 23:28:52 -0800, Brad Boyer <flar@allandria.com> wrote:
> 
> I have one suggestion about this part of the code.
> 
> On Mon, Feb 01, 2010 at 11:04:45AM +0530, Aneesh Kumar K.V wrote:
> 
> <snip>
> 
> > +/*
> > + * ACL entries that have ACE4_SPECIAL_WHO set in ace->e_flags use the
> > + * pointer values of these constants in ace->u.e_who to avoid massive
> > + * amounts of string comparisons.
> > + */
> > +
> > +const char richace_owner_who[]	  = "OWNER@";
> > +EXPORT_SYMBOL_GPL(richace_owner_who);
> > +const char richace_group_who[]	  = "GROUP@";
> > +EXPORT_SYMBOL_GPL(richace_group_who);
> > +const char richace_everyone_who[] = "EVERYONE@";
> > +EXPORT_SYMBOL_GPL(richace_everyone_who);
> 
> <snip>
> 
> > +/*
> > + * richace_is_same_who  -  do both acl entries refer to the same identifier?
> > + */
> > +int
> > +richace_is_same_who(const struct richace *a, const struct richace *b)
> > +{
> > +#define WHO_FLAGS (ACE4_SPECIAL_WHO | ACE4_IDENTIFIER_GROUP)
> > +	if ((a->e_flags & WHO_FLAGS) != (b->e_flags & WHO_FLAGS))
> > +		return 0;
> > +	if (a->e_flags & ACE4_SPECIAL_WHO)
> > +		return a->u.e_who == b->u.e_who;
> > +	else
> > +		return a->u.e_id == b->u.e_id;
> > +#undef WHO_FLAGS
> > +}
> > +
> > +/**
> > + * richacl_set_who  -  set a special who value
> > + * @ace:	acl entry
> > + * @who:	who value to use
> > + */
> > +int
> > +richace_set_who(struct richace *ace, const char *who)
> > +{
> > +	if (!strcmp(who, richace_owner_who))
> > +		who = richace_owner_who;
> > +	else if (!strcmp(who, richace_group_who))
> > +		who = richace_group_who;
> > +	else if (!strcmp(who, richace_everyone_who))
> > +		who = richace_everyone_who;
> > +	else
> > +		return -EINVAL;
> > +
> > +	ace->u.e_who = who;
> > +	ace->e_flags |= ACE4_SPECIAL_WHO;
> > +	ace->e_flags &= ~ACE4_IDENTIFIER_GROUP;
> > +	return 0;
> > +}
> > +EXPORT_SYMBOL_GPL(richace_set_who);
> > +
> > +/**
> > + * richacl_allowed_to_who  -  mask flags allowed to a specific who value
> > + *
> > + * Computes the mask values allowed to a specific who value, taking
> > + * EVERYONE@ entries into account.
> > + */
> > +static unsigned int
> > +richacl_allowed_to_who(struct richacl *acl, struct richace *who)
> > +{
> > +	struct richace *ace;
> > +	unsigned int allowed = 0;
> > +
> > +	richacl_for_each_entry_reverse(ace, acl) {
> > +		if (richace_is_inherit_only(ace))
> > +			continue;
> > +		if (richace_is_same_who(ace, who) ||
> > +		    richace_is_everyone(ace)) {
> > +			if (richace_is_allow(ace))
> > +				allowed |= ace->e_mask;
> > +			else if (richace_is_deny(ace))
> > +				allowed &= ~ace->e_mask;
> > +		}
> > +	}
> > +	return allowed;
> > +}
> 
> <snip>
> 
> > +struct richace {
> > +	unsigned short	e_type;
> > +	unsigned short	e_flags;
> > +	unsigned int	e_mask;
> > +	union {
> > +		unsigned int	e_id;
> > +		const char	*e_who;
> > +	} u;
> > +};
> 
> <snip>
> 
> > +/* Special e_who identifiers: we use these pointer values in comparisons
> > +   instead of strcmp for efficiency. */
> > +
> > +extern const char richace_owner_who[];
> > +extern const char richace_group_who[];
> > +extern const char richace_everyone_who[];
> > +
> > +static inline int
> > +richace_is_owner(const struct richace *ace)
> > +{
> > +	return (ace->e_flags & ACE4_SPECIAL_WHO) &&
> > +	       ace->u.e_who == richace_owner_who;
> > +}
> > +
> > +static inline int
> > +richace_is_group(const struct richace *ace)
> > +{
> > +	return (ace->e_flags & ACE4_SPECIAL_WHO) &&
> > +	       ace->u.e_who == richace_group_who;
> > +}
> > +
> > +static inline int
> > +richace_is_everyone(const struct richace *ace)
> > +{
> > +	return (ace->e_flags & ACE4_SPECIAL_WHO) &&
> > +	       ace->u.e_who == richace_everyone_who;
> > +}
> > +
> > +static inline int
> > +richace_is_unix_id(const struct richace *ace)
> > +{
> > +	return !(ace->e_flags & ACE4_SPECIAL_WHO);
> > +}
> 
> Wouldn't it make more sense to just store some small numeric value
> in ace->u.e_who rather than a pointer? It seems to me that the
> savings of storing and comparing an integer type would more than
> make up for the slight overhead of needing to lookup a pointer
> in the places where the code must handle an external representation.
> I know there is really only a difference on 64-bit systems, but my
> impression has been that most people are going that way. In particular,
> the struct richace would go to 12 bytes with 4-byte alignment from
> 16 bytes with 8-byte alignment on an architecture with 8-byte pointers.
> Plus doing an integer instead of a pointer should eliminate the need
> to export the constant pointer values. Even in 32-bit, there are a
> few odd architectures (like m68k) that have separate address and
> data registers, so using an integer may have some benefits there
> due to the fact that the instruction set treats them differently.
> 
> I know you mentioned that you didn't originally write this code, but
> it seems a logical change to me.

I guess id mapping needs more work in the patch. I would really like
to hear from both NFS and Samba people in how they would like the
id details to be stored. If we can't map an incoming user@domain
request on nfs, I guess we definitely don't want to store the acl with
'nobody' id

-aneesh
